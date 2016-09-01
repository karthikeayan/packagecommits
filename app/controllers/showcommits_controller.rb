class ShowcommitsController < ApplicationController
  require 'date'
  require 'mysql'

  def index

  end

  def fetch
    @commits = {}
    begin
      conn = Mysql.new 'localhost', 'root', 'root', 'dashboard'
      rs = conn.query 'SELECT * FROM merge_data'
      n_rows = rs.num_rows
    
      (1..n_rows).each do |i|
        @commits[i] = {}
      end

      (1..n_rows).each do |i|
        tmp_array = rs.fetch_row
        @commits[i]['userstory'] = tmp_array[0]
        @commits[i]['projectname'] = tmp_array[1]
        @commits[i]['branchname'] = tmp_array[2]
        @commits[i]['timestamp'] = tmp_array[3]
        @commits[i]['commitid'] = tmp_array[4]
        @commits[i]['email'] = tmp_array[5]
        @commits[i]['comment'] = tmp_array[6]
        @commits[i]['packagename'] = tmp_array[7]
      end
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      conn.close if conn
    end
  end
end
