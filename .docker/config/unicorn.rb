root_path = File.expand_path(File.join(File.dirname(__FILE__), ".."))
#shared_path = File.expand_path(File.join(root_path, "..", "shared"))

working_directory root_path
pid root_path + "/pids/unicorn.pid"
stderr_path root_path + "/log/unicorn.log"
stdout_path root_path + "/log/unicorn.log"

listen "/tmp/unicorn_medicaid_gateway.ap.sock"
worker_processes 1
timeout 90
preload_app true

after_fork do |server, worker|
  Rails.logger.info { "Rebooting Validation Proxy for worker" }
  AtpBusinessRulesValidationProxy.reconnect!
end
