module CfCanaries
  class CommandRunner
    EMPTY_ENVIRONMENT = {}.freeze

    def initialize(logger, dry_run, cf_command)
      @logger = logger
      @dry_run = dry_run
      @cf_command = cf_command
    end

    def cf!(command, options={})
      run!("#{@cf_command} #{command}", options[:skip_logging_command], options[:hide_command_output], options[:password])
    end

    private

    def run!(command, skip_logging_command, hide_command_output, password)
      @logger.info(command) unless skip_logging_command

      return if @dry_run

      pid = spawn(command, hide_command_output)

      _, status = Process.wait2(pid)

      if !status.success?
        error_message = "Command failed: #{command.inspect})"
        error_message = error_message.gsub(/#{password}/,"REDACTED") if password

        raise error_message
      end
    end

    def spawn(command, hide_command_output)
      spawn_options = hide_command_output ? {:out => '/dev/null', :err => '/dev/null'} : {}

      Process.spawn(EMPTY_ENVIRONMENT, 'bash', '-c', command, spawn_options)
    rescue => e
      raise "Spawning command failed: #{e.message}\n#{e.backtrace}"
    end
  end
end
