require_relative('token.rb')
require_relative('state')
require_relative('token_type')
require_relative('parser')

class Tokenizer

  def self.reverse(hex)
    split = hex.scan(/.{2}/)
    reverse = ''

    split.reverse.each do |piece|
      reverse << piece
    end
    reverse
  end

	def initialize
		@line_number = 0
		@state = State::INITIAL
    @commands = %w(MOVW MOVT ADD LDR ORR STR B)
    @conditions = %w(AL NE EQ)
    @command_number = 0
    @labels = Hash.new

	end

	def tokenize(line)
		@line_number += 1
		string = String.new
    tokens = []
    labels = Hash.new()

    tokens.push(Token.new(TokenType::LINE_NUMBER, @line_number))
    # Assemble command string stripping out comments
    line.split('').each do |character|

      if is_comment? character
        @state = State::COMMENT
        puts 'Stripping out comment'
			elsif (@state != State::COMMENT) && ((is_alpha_numeric? character) || (is_white_space? character))
        string << character
			end

    end

    puts "Command #{string}" unless string.empty?
    @command_number += 1 unless string.empty?

    components = string.split ' '

    components.each do |component|
      if is_label_declaration? component
        puts "#{component} is a label for command number #{@command_number}"
        component.gsub!(':', '')
        @labels[component] = @command_number

      elsif is_label? component
        puts "#{component} is using the label"
        token = Token.new(TokenType::LABEL, @labels[component])
        tokens.push(token)

      elsif is_command? component
        puts "#{component} is a valid command"
        token = Token.new(TokenType::COMMAND, component)
        tokens.push(token)

      elsif is_register? component
        puts "#{component} is a register"
        token = Token.new(TokenType::REGISTER, component)
        tokens.push(token)

      elsif is_offset? component
        puts "#{component} is an offset"
        token = Token.new(TokenType::OFFSET, component)
        tokens.push(token)
      elsif is_condition? component
        puts "#{component} is a condition"
        token = Token.new(TokenType::CONDITION, component)
        tokens.push(token)
      end
    end

    parser = Parser.new
    @state = State::INITIAL
    @labels.each do |label|
      puts label
    end
    parser.assemble(tokens, @command_number)

	end


	private
	def is_alpha_numeric?(character)
		character.match(/^[[a-zA-Z0-9]]$|^:|-$/)
	end

	def is_white_space?(character)
		character.match(/^[[\s]]$/)
	end

	def is_comment?(character)
		character.match(/^[[;]]$/)
  end

  def is_command?(string)
    found = nil
    @commands.each do |command|
      found = string =~ /#{command}/

      if found
        break
      end
    end
    found
  end

  def is_register?(symbol)
    /R[0-9]/.match(symbol)
  end

  def is_offset?(symbol)
    /[0-9]*x[0-9]*|-*[0-9]+/.match(symbol)
  end

  def is_label_declaration?(symbol)
    /[a-z]*:/.match(symbol)
  end

  def is_label?(symbol)
    @labels[symbol]
  end

  def is_condition?(symbol)
    condition_string = ''
    @conditions.each do |condition|
      condition_string << condition
    end

    condition_string.gsub!(' ', '|')

    condition_string.match(symbol)
  end

end