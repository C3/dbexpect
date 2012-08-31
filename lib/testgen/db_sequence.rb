class DbSequence
  def initialize
    @sequence = 0
  end

  def db_str
    @sequence += 1
    @sequence.to_s
  end
end
