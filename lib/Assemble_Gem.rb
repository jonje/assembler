require_relative "Assemble_Gem/version"
require_relative 'tokenizer'
require_relative 'preprocessor'

module AssembleGem

  # Your code goes here...
  # Read in file and open it.
  file = File.open(ARGV[0],"r+").read()

  binary = []
  hexs = []
  preprocessor = Preprocessor.new


  # Preprocess to get all the labels before hand.
  file.each_line do |line|
    preprocessor.process line
  end

  labels = preprocessor.get_labels
  tokenizer = Tokenizer.new(labels)
  # Loop through each line tokenize each line
  file.each_line do |line|
    #tokenize each line of code
    binary_representation = tokenizer.tokenize(line)

    if !binary_representation.empty?
      binary.push(binary_representation)

    end

  end

  binary.each {|string| puts string}

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


  puts 'Writing to file'
  File.open(File.expand_path('~') + '/Desktop/kernel7.txt', 'wb') do |file|
    hexs.each do |hex|
      temp = hex.scan(/.{2}/)
      temp.each {|bit| file << bit}

    end
  end
  puts 'Done writing to file'


end


