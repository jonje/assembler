require_relative "Assemble_Gem/version"
require_relative 'tokenizer'

module AssembleGem



  # Your code goes here...
  # Read in file and open it.
  file = File.open(ARGV[0],"r+").read()

  binary = []
  hexs = []

# Loop through each line
  file.each_line do |line|
    tokenizer = Tokenizer.new
    #tokenize each line of code
    binary_representation = tokenizer.tokenize(line)

    if !binary_representation.empty?
      binary.push(binary_representation)
    end

  end

  binary.each do |string|
    split = string.scan(/.{4}/)
    hex = ''
    split.each do |something|
      hex << something.to_i(2).to_s(16)
    end
    hexs.push(Tokenizer.reverse(hex))
  end

  hexs.each do |binary|
    puts binary
  end


end


