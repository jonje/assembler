require_relative('token')
require_relative('token_type')

class Parser
  @tokens = nil

  def initialize
    @conditions = {'AL' => '1110', 'NE' => '0001', 'EQ' => '0000'}
  end

  def assemble(tokens)
    @tokens = tokens
    binary_command = ''

    command = get_command
    if command != nil
      cond = get_condition

      binary_command << cond
      base = get_base(command)

      binary_command << base

      offset = get_offset(get_bit_amount(command))
      puts "Offset is #{offset}"

      registers = get_registers

      if command.match(/ADD|LDR|STR|SUB/)
        binary_command = set_registers(binary_command, registers)
      elsif command.match(/MOV|B/)
        first_chunck = offset[0..3]
        puts "First chunck is #{first_chunck}"
        binary_command << first_chunck
        offset[0..3] = ''
        binary_command = set_registers(binary_command, registers)
        puts "Final Offset is #{offset}"

      end

      binary_command << offset

      puts "Binary representation #{binary_command}"

    else
      puts "Command is nil"
    end

    binary_command

  end

  private
  def set_registers(binary_command, registers)
    if registers.kind_of? Array
      registers.each do |register|
        register = convert_register_to_binary register
        puts "Register is #{register}"
        binary_command << register
      end
    else
      puts "Register is #{register}"
      binary_command << registers
    end

    binary_command
  end

  def get_command
    result = nil
    @tokens.each do |token|
      if token.type == TokenType::COMMAND
        result = token.value
        break
      end
    end

    result
  end

  def get_base(command)
    result = nil
    if command.match(/MOVW/)
      result = '00110000'
    elsif command.match(/MOVT/)
      result = '00110100'
    elsif command.match(/ADD/)
      s_bit = 0
      if command.match(/S/)
        s_bit = 1
      end
      result = "0010100#{s_bit}"
    elsif command.match(/LDR/)
      p_bit = command.match(/P/) ? 1 : 0
      u_bit = command.match(/U/) ? 1 : 0
      w_bit = command.match(/W/) ? 1 : 0

      result = "010#{p_bit}#{u_bit}0#{w_bit}1"
    elsif command.match(/STR/)
      p_bit = command.match(/P/) ? 1 : 0
      u_bit = command.match(/U/) ? 1 : 0
      w_bit = command.match(/W/) ? 1 : 0

      result = "010#{p_bit}#{u_bit}0#{w_bit}0"
    elsif command.match(/SUB/)
      s_bit = command.match(/S/) ? 1 : 0

      result = "0010010#{s_bit}"
    elsif command.match(/B/)
      result = '1010'
    end
    result
  end

  def get_condition
    condition = 'AL'
    @tokens.each do |token|
      if token.type == TokenType::CONDITION
        condition = token.value
        break
      end
    end

    result = @conditions[condition]
  end

  def get_offset(bit_amount)
    result = 0
    @tokens.each do |token|
      if token.type == TokenType::OFFSET
        value = token.value

        if value.match(/-/)
          max = 2** bit_amount
          value.gsub!('-', '')
          temp = value.to_i

          result = max - temp

        elsif value.match(/[0-9]*x[0-9]*/)
          result = value.to_i(16)
          puts "reached good spot #{result}"
        else
          result = value.to_i
          puts "Bad should not reach here"
        end

        break
      end
    end


    result = result.to_bin(bit_amount)

    result.to_s
  end

  def get_bit_amount(command)
    result = nil
    if command.match(/MOV/)
      result = 16
    elsif command.match(/ADD|LDR|STR|SUB/)
      result = 12
    elsif command.match(/B/)
      result = 24
    end

    result
  end

  def get_register_as_binary
    result = ''
    @tokens.each do |token|
      if token.type == TokenType::REGISTER
        temp = token.value
        temp.gsub!(/[a-zA-Z]/, '')
        int = temp.to_i
        result = int.to_bin(4)

        break
      end
    end

    result.to_s
  end

  def convert_register_to_binary(register)
    value = register.gsub(/[a-zA-Z]/, '')
    puts "Register is #{value} without letter in front"
    int = value.to_i
    result = int.to_bin(4)
    puts "Result = #{result}"
    result
  end

  def get_registers
    results = []
    @tokens.each do |token|
      if token.type == TokenType::REGISTER
        results.push(token.value)
      end
    end
    results
  end

end

class Integer
  def to_bin(width)
    '%0*b' % [width, self]
  end
end