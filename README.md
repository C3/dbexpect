dbexpect
=======

dbexpect is an ETL unit testing tool written in ruby

Taking cues from Rspec in structure and usage, the point is to enable
the specification of unit test data, job running, and expected outcomes
for an entity/test cases in a ruby file using an internal DSL that is
targeted at this kind of testing.

dbexpect is ideally suited to creating automated unit tests for
individual ETL jobs in a data warehousing or data migration project.
Helping to ensure correctness of the job initially developed, and
catching problems later on when someone makes a change that could affect
existing functionality.

dbexpect's expected audience is ETL developers, ie people who use
Datastage, Informatica, Pentaho, SSIS etc on a day to day basis

Sample test
---------

    describe "Moving customers from source to target" do
      @src = table(:dbexpect_src,:dbexpect_src,:customers_src)
      @tgt = table(:dbexpect_tgt,:dbexpect_tgt,:customers_tgt)

      etl_run_command "ruby etl2.rb"

      expect_total_rows @tgt, 1

      describe "it should upcase customer names" do
        insert_into @src,
          [:id,:name],
          [[1,"Fred"]]

        expect_rows @tgt,
          [:id,:name],
          [[1,"FRED"]]
      end

      describe "it should not migrate smith (because screw that guy)" do
        insert_into @src,
          [:id,:name],
          [[1,"Smith"]]

        # expect no rows
      end
    end

Installation
------------
    gem install dbexpect
    
Create a database.yml file in a folder where you want to store your
tests, and set up connections for each of the databases you want dbexpect
to talk to. Each of the connections will need to have an ODBC connection
defined as well.

database.yml:

    database1:
      database: odbc_dsn
      username: barry
      password: secret

    database2:
      database: odbc_dsn2
      username: shaz
      password: secret

Usage
-----
Assuming a folder structure for your tests that looks like this:

    /
    |-database.yml
    |
    |- defaults/
    |          |- defaults_for_tablex.rb
    |
    |- tests/
            |- test1.rb
            |- test2.rb

To run the tests in test1.rb:

    prompt:/$ dbexpect tests/test1.rb

There is a sample dbexpect project at
http://github.com/C3/dbexpect_example for more information.


Thanks
------
Many thanks to my employer C3 Products, for giving me the time to work on things
that interest me like this and then allowing us to give them away for
free. http://www.c3products.com.au

License
-------

Copyright 2012 C3 Products. See COPYING for further details.

dbexpect is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

dbexpect is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with dbexpect.  If not, see <http://www.gnu.org/licenses/>.
