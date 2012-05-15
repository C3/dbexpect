class ConsoleFormatter
  def initialize(output)
    @output = output
  end

  def notify_passed
    @output.puts "Passed all expectations\n"
  end

  def notify_failed(failed_expectations)
    failed_expectations.traverse do |depth, description, expectations|
      @output.puts(('  ' * depth) + description + ":\n")

      expectations.collect(&:failure_message).each do |msg|
        @output.puts(('  ' * depth) + ' ' + msg + "\n")
      end
    end
    @output.puts "Failed to meet expectations\n"
  end

  def format_sql(sql)
    @output.puts sql
  end
end
