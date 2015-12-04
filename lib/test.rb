require_relative('state')
string = "MOVT R4, 0"
commands = ['MOVW', 'MOVT', 'LDR']
command = nil
count = 0

commands.each do |command|
	if string =~ /^#{command}/
		command = string.match(/^#{command}/)
		puts command
		count += 1
	end
end

puts count 
