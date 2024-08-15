module RexPort
  class ChildConfig
    attr_reader :chdir, :timeout, :command

    def initialize(command, working_dir, timeout = -1)
      @chdir = working_dir
      @command = command
      @timeout = timeout
    end

    def boot!
      error_reader, errors_from_validator = IO.pipe(binmode: true)
      reader, write_from_validator = IO.pipe(binmode: true)
      read_into_validator, writer = IO.pipe(binmode: true)
      pid = nil
      begin
        pid = Process.spawn(
          @command,
          chdir: @chdir,
          :in => read_into_validator,
          :out => write_from_validator,
          :err => errors_from_validator,
          error_reader.fileno => :close,
          reader.fileno => :close,
          writer.fileno => :close
        )
      rescue StandardError => e
        raise Errors::StartupError.new(e)
      end
      Process.detach(pid)
      write_from_validator.close
      read_into_validator.close
      errors_from_validator.close
      [pid, reader, writer, error_reader]
    end
  end
end