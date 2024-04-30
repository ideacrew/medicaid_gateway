module RexPort
  class Child
    attr_reader :pid, :reader, :writer, :error_reader, :child_config

    def initialize(child_config, boot = false)
      @child_config = child_config
      boot! if boot
    end

    def request(message)
      tell(message)
      listen
    end

    def reboot!
      kill!
      boot!
    end

    def boot!
      @pid, @reader, @writer, @error_reader = @child_config.boot!
      check_status = check_process_death
      unless check_status.empty?
        raise Errors::StartupError.new(check_status.last)
      end
    end

    def kill!
      @writer.close
      @reader.close
      @error_reader.close
      begin
        Process.kill(9, @pid)
        Process.waitpid(@pid)
      rescue Errno::ECHILD, Errno::ESRCH
      end
    end

    protected

    def tell(message)
      check_status = check_process_death
      unless check_status.empty?
        raise Errors::DiedBeforeListeningError.new(check_status.last)
      end
      packet_size = [message.bytesize].pack("l>*")
      @writer.write(packet_size)
      @writer.write(message)
      @writer.flush
    end

    def listen
      readable = nil
      if @child_config.timeout > 0
        readable = IO.select([@reader, @error_reader], [], [@error_reader], @child_config.timeout)
      else
        readable = IO.select([@reader, @error_reader], [], [@error_reader])
      end
      unless readable
        reboot!
        raise Errors::ResponseTimeoutError, "process timeout!"
      end

      first_readable_array = readable.detect { |item| !item.empty? }
      if first_readable_array.first.fileno == @error_reader.fileno
        read = try_read_nonblock(first_readable_array.first)
        reboot!
        raise Errors::ResponseReadError, read
      end

      packet_response_size = @reader.read(4)
      if packet_response_size.nil? || packet_response_size.bytesize < 4
        check_result = check_process_death
        reboot!
        raise Errors::ResponseReadError, "process crashed:\n#{check_result.last}"
      end
      read_size = packet_response_size.unpack("L>*")
      read_buff = @reader.read(read_size.first)
      check_result = check_process_death
      unless check_result.empty?
        reboot!
        raise Errors::ResponseReadError, "process crashed:\n#{check_result.last}"
      end
      read_buff
    end

    def check_process_death
      pid_status = nil
      begin
        pid_status = Process.waitpid(@pid, Process::WNOHANG)
        return [] unless pid_status
      rescue Errno::ECHILD
        pid_status = -1
      end
      read_death_data = try_read_nonblock(@error_reader)
      [pid_status, read_death_data]
    end

    def try_read_nonblock(io)
      begin
        io.read_nonblock(2**16)
      rescue EOFError
        ""
      end
    end
  end
end
