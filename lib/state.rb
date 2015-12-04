require_relative 'enum'
class State < Enum
	self.add_item(:COMMENT, 'comment')
	self.add_item(:INITIAL, 'initial')
	
end