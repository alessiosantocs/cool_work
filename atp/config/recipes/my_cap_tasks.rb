
Capistrano.configuration(:must_exist).load do

  set :config_files, [ 'database.yml', 'mongrel_cluster.yml']

  desc "Copy production database.yml to live app"
  task :copy_config_files do
    config_files.each do |file|
      run "cp #{shared_path}/config/#{file} #{release_path}/config/"
    end
  end


end


class Capistrano::Actor

  ##
  # Run a command as root and stream it back

  def sudo_stream(command)
    sudo(command) do |channel, stream, out|
      puts out if stream == :out
      if stream == :err
        puts "[err : #{channel[:host]}] #{out}"
        break
      end
    end
  end

  # Run a task and ask for input when input_query is seen.
  # Sends the response back to the server.
  #
  # +input_query+ is a regular expression.
  #
  # Can be used where +run+ would otherwise be used.
  #
  #  run_with_input 'ssh-keygen ...'
  def run_with_input(shell_command, input_query=/^Password/)
    handle_command_with_input(:run, shell_command, input_query)
  end

  # Run a task as root and ask for input when a regular expression is seen.
  # Sends the response back to the server.
  #
  # +input_query+ is a regular expression
  def sudo_with_input(shell_command, input_query=/^Password/)
    handle_command_with_input(:sudo, shell_command, input_query)
  end

  private

  # Do the actual capturing of the input and streaming of the output.
  def handle_command_with_input(local_run_method, shell_command, input_query)
    send(local_run_method, shell_command) do |channel, stream, data|
      logger.info data, channel[:host]
      if data =~ input_query
        pass = Capistrano::CLI.password_prompt "#{data}:"
        channel.send_data "#{pass}\n"
      end
    end
  end

end
