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
