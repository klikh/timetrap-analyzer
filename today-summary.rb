require 'pathname'
app_root = File.dirname(Pathname.new(__FILE__).realpath)
require app_root + '/tt-analyzer-lib.rb'

class Timetrap::Formatters::Today 
  include TimeTrapAnalyzer
  
  def initialize(entries)
    @entries = entries
  end

  def output
    day_summary(@entries.reject{ |entry| entry[:start].to_date != Date.current })
  end
  
end