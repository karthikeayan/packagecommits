class ShowcommitsController < ApplicationController
  require 'date'
  require 'mysql'

  def index

  end

  def fetch
    @commits = {}
    @branches = []
    logger.debug 'branch_name: ' + params[:branch_name].inspect
    
    begin
      conn = Mysql.new 'localhost', AUTHENTICATION['username'], AUTHENTICATION['password'], AUTHENTICATION['database']

      rs = conn.query 'SELECT DISTINCT branchname FROM merge_data'
      n_rows = rs.num_rows
      (1..n_rows).each do |i|
        @branches.push(rs.fetch_row)
      end
      @branches = @branches.flatten
      logger.debug 'branches: ' + @branches.inspect

      rs = nil
      if params[:branch_name].nil?
        rs = conn.query 'SELECT * FROM merge_data'
      else
        query = 'SELECT * FROM merge_data where branchname="' + params[:branch_name] + '"'
        rs = conn.query query
      end

      n_rows = rs.num_rows
      logger.debug 'rs: ' + rs.inspect
    
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
      logger.error e.errno
      logger.error e.error
    ensure
      conn.close if conn
    end
    logger.debug 'commits: ' + @commits.inspect
  end
end
