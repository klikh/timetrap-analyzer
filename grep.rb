require 'pathname'
app_root = File.dirname(Pathname.new(__FILE__).realpath)
require app_root + '/tt-analyzer-lib.rb'

class Timetrap::Formatters::Grep 
  include TimeTrapAnalyzer
  
  def initialize(entries)
    @entries = entries
  end

  def output1
    day_summary(@entries.select{ |entry| is_git_talk?(entry)})
  end
  
  def is_git_talk?(entry)
    dc = entry[:note].downcase ; dc.include?("git") && dc.include?("talk")
  end
  
  def output2
    @entries.select{ |entry| is_git_talk?(entry)}.map{|entry| "#{entry[:id]} #{entry[:note]}"}
  end
  
  def output
    @entries.select{|entry| entry[:note].start_with?("B")}.map{|e| "#{e[:id]}"}
  end
  
end