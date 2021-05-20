# frozen_string_literal: true

# Proxies to a shelled-out java validator for the schematron rules.
# Nokogiri is based on libxml2 - which currently doesn't support the needed
# protocols for schematron.
class AtpBusinessRulesValidationProxy
  include Singleton

  WORKING_DIRECTORY = File.expand_path(Rails.root).freeze

  def self.boot!
    instance.boot_port_process
  end

  def self.reconnect!
    instance.reconnect!
  end

  def self.run_validation(data)
    instance.run_validation(data)
  end

  def boot_port_process
    @error_reader, @errors_from_validator = IO.pipe(binmode: true)
    @reader, @write_from_validator = IO.pipe(binmode: true)
    @read_into_validator, @writer = IO.pipe(binmode: true)
    @pid = Process.spawn(
      "java -jar lib/atp_validator-0.1.0-jar-with-dependencies.jar",
      chdir: WORKING_DIRECTORY,
      :in => @read_into_validator,
      :out => @write_from_validator,
      :err => @errors_from_validator
    )
  end

  def run_validation(data)
    data_size = data.bytesize
    packet_size = [data_size].pack("l>*")

    @writer.write(packet_size)
    @writer.write(data)
    @writer.flush

    readable = IO.select([@reader, @error_reader], [], [@error_reader], 10)
    unless readable
      reconnect!
      raise StandardError, "process timeout!"
    end
    first_readable_array = readable.detect { |item| !item.empty? }
    if first_readable_array.first.fileno == @error_reader.fileno
      read = first_readable_array.first.read_nonblock(2**16)
      reconnect!
      raise StandardError, read
    end

    packet_response_size = @reader.read(4)
    read_size = packet_response_size.unpack1("L>*")
    read_buff = @reader.read(read_size)
    pid_status = Process.waitpid(@pid, Process::WNOHANG)
    # Whoops, we crashed it.
    unless pid_status.nil?
      reconnect!
      raise StandardError, "process crashed!"
    end
    read_buff
  end

  def reconnect!
    return if @pid.blank?
    @reader.close
    @writer.close
    @write_from_validator.close
    @read_into_validator.close
    @error_reader.close
    @errors_from_validator.close
    Process.kill(9, @pid)
    Process.waitpid(@pid)
    boot_port_process
  end
end