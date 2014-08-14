project_name = 'test_app'
user = 'ubuntu'
root = "/home/#{ user }/#{ project_name }/current"
working_directory root
pid "/home/#{user}/#{ project_name }/shared/tmp/pids/unicorn.pid"
stderr_path "/home/#{user}/#{project_name}/shared/log/unicorn.stderr.log"
stdout_path "/home/#{user}/#{project_name}/shared/log/unicorn.stdout.log"

listen "/home/#{user}/#{project_name}/shared/tmp/sockets/unicorn.sock"
worker_processes 2
timeout 30
preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
     begin
       sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
       Process.kill(sig, File.read(old_pid).to_i)
     rescue Errno::ENOENT, Errno::ESRCH
     end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
