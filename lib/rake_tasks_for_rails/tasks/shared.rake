namespace :shared do

  task :confirm, [:action, :token] do |t, args|
    confirm_token = args[:token]
    action = args[:action]
    STDOUT.puts "Confirm: #{action}? Enter '#{confirm_token}' to confirm:"
    input = STDIN.gets.chomp
    raise "Aborting #{action}. You entered '#{input}'' instead of '#{confirm_token}'" unless input == confirm_token
  end

end