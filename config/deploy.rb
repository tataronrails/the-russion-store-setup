# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'test_app'
set :repo_url, 'git@github.com:tataronrails/the-russion-store-setup.git'
set :branch, 'master'
set :scm, :git
set :format, :pretty

set :ip_machine, '104.131.198.171'
set :user, 'ubuntu'
set :rails_env, 'production'
set :domain, "#{ fetch(:user) }@#{ fetch(:ip_machine) }"
set :deploy_to, "/home/#{ fetch(:user) }/#{ fetch(:application) }"
set :use_sudo, false
set :format, :pretty
set :pty, true

set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :unicorn_config_path, "#{ fetch(:deploy_to) }/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid"

set :tmp_dir, "#{fetch(:deploy_to)}/shared/tmp"
set :pg_user, 'test_app_production'

set :ssh_options, {
    user: 'root' ,
    forward_agent: false,
    auth_methods: %w(publickey password) }

set :linked_dirs, fetch(:linked_dirs) + %w{log
                                           tmp/sockets
                                           tmp/pids}
set :pg_user, 'test_app_production'
set :format, :pretty
set :nginx_template, "nginx.conf"

after 'deploy', 'unicorn:restart'
namespace :unicorn do
  task :restart do
    invoke 'unicorn:restart'
  end
end

namespace :nginx do
  task :update_conf do
    on roles(:app) do
      execute :sudo, :service, :nginx, :stop
      execute :sudo, :cp, "#{ fetch(:deploy_to) }/current/#{ fetch(:nginx_template) }", '/etc/nginx/nginx.conf'
      execute :sudo, :service, :nginx, :start
    end
  end
end
