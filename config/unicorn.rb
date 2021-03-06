APP_PATH = ENV.fetch("APP_ROOT_PATH") { "/usr/src/app" }

listen            3000
timeout 300
working_directory "#{APP_PATH}"
pid "#{APP_PATH}/shared/tmp/pids/unicorn.pid"

stderr_path       "#{APP_PATH}/logs/unicorn_err.log"
stdout_path       "#{APP_PATH}/logs/unicorn.log"
worker_processes  4
preload_app       true

before_fork do |server, worker|

  old_pid = "#{server.config[:pid]}.oldbin"

  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill sig, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 1
end
