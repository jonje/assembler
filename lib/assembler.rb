require_relative 'tokenizer'
# Read in file and open it.
file = File.open(ARGV[0],"r+").read()

tokens = Array.new 
tokenizer = Tokenizer.new

# Loop through each line
file.each_line do |line|
	#tokenize each line of code
	tokenizer.tokenize(line)
end

