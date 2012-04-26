class DbString
  def initialize(str)
    @string = str
  end

  def db_str
    "'#{@string}'"
  end
end
