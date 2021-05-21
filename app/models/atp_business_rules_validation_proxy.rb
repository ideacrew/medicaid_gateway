# frozen_string_literal: true

# Proxies to a shelled-out java validator for the schematron rules.
# Nokogiri is based on libxml2 - which currently doesn't support the needed
# protocols for schematron.
#
# The jar itself lives in lib/atp_validator-0.1.0-jar-with-dependencies.jar.
# The repository for the code is: https://github.com/ideacrew/atp_validator
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
      :err => @errors_from_validator,
      @error_reader.fileno => :close,
      @reader.fileno => :close,
      @writer.fileno => :close
    )
    Process.detach(@pid)
    @write_from_validator.close
    @read_into_validator.close
    @errors_from_validator.close
    check_process_death
    @pid
  end

  def check_process_death(stage = "boot")
    pid_status = nil
    begin
      pid_status = Process.waitpid(@pid, Process::WNOHANG)
      return unless pid_status
    rescue Errno::ECHILD
      pid_status = -1
    end
    read_death_data = @error_reader.read_nonblock(2**16)
    Rails.logger.error do
      "Process died during #{stage}: #{@pid}\n#{read_death_data}"
    end
    pid_status
  end

  def run_validation(data)
    packet_size = [data.bytesize].pack("l>*")

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
      Rails.logger.error { "Validator Crashed:\n#{read}" }
      reconnect!
      raise StandardError, read
    end

    packet_response_size = @reader.read(4)
    read_size = packet_response_size.unpack1("L>*")
    read_buff = @reader.read(read_size)
    pid_status = check_process_death("run")
    unless pid_status.nil?
      reconnect!
      raise StandardError, "process crashed!"
    end
    read_buff
  end

  # rubocop:disable Lint/SuppressedException
  def reconnect!
    unless @pid.blank?
      @reader.close
      @writer.close
      @error_reader.close
      Process.kill(9, @pid)
      begin
        Process.waitpid(@pid)
      rescue Errno::ECHILD
      end
    end
    boot_port_process
  end
  # rubocop:enable Lint/SuppressedException
end