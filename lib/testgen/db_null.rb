class DbNull
  def db_str
    'NULL'
  end

  def equality_test
    "is null"
  end
end
