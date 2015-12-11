class Preprocessor

  def initialize
    @labels = Hash.new
    @command_count = 0
  end


  def process(line)

    @command_count += 1 unless /^;+/.match(line)
    a = /[a-z]+:/.match(line).to_s
    if a != nil
      a.gsub!(':', '')
      @labels[a] = @command_count
    end
  end

  def get_labels
    @labels
  end
end