class ConsoleFormatter
  def initialize(output)
    @output = output
  end

  def notify_passed
    @output.puts "Passed all expectations\n"
  end

  def notify_failed(failed_expectations)
    @output.puts failed_expectations.collect(&:failure_message).join("\n")
    @output.puts "Failed to meet expectations\n"
  end

  def format_sql(sql)
    @output.puts sql
  end
end
