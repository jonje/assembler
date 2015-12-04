require_relative('enum')
class TokenType < Enum
	self.add_item(:COMMAND, 'command')
	self.add_item(:FLAG, 'flag')
	self.add_item(:PARAMETER, 'parameter')
	self.add_item(:REGISTER, 'register')
  self.add_item(:LINE_NUMBER, 'line_number')
  self.add_item(:OFFSET, 'offset')
  self.add_item(:CONDITION, 'condition')
end