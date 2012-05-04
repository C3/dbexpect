= testgen

Testgen is a domain specific language written in ruby for targeted at
testing ETL solutions.

Taking cues from Rspec in structure and usage, the point is to enable
the specification of unit test data, job running, and expected outcomes
for an entity/test cases in a ruby file using an internal DSL that is
targeted at this kind of testing.

Currently testgen can be used to generate a bunch of insert statements
for the data you specify as being needed (both source and expected 
results) so that you can run these into a database somewhere for later
use.

The next part of the plan is to point testgen at a database and have it
validate that any expected data specified is there.

An example test definition:

    requires 'spec/fixtures/system_wide_reusable_defaults.rb'
    
    describe "our basic test definition test" do
      @src = table(:source,:src_table)
      @tgt = table(:target,:tgt_table)

      defaults_for @src,
        :str_column => "default string",
        :nullable_col => NULL
    
      expected_defaults @tgt,
        :str_column => 'defaulted in script',
        :int_column => 5
    
    
      describe "test case 1" do
        insert_into @src,
          [:int_column],
          [[7]]
    
        expect_rows @tgt,
          [:nullable_col],
          [
            [NULL],
            [nil],
            [null],
            [4] ]
      end
    
    end


Data is specified by constantly defining and overriding default values
for columns for tables, then creating actual rows using insert_rows and
expect_rows. This allows very wide column tables to have a whole heap of
defaults specified in shared files that can be required, and then
override the values for the columns you actually care about for the test

== Copyright

Copyright (c) 2012 Beau Fabry. See LICENSE.txt for
further details.

