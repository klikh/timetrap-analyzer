require 'pathname'
app_root = File.dirname(Pathname.new(__FILE__).realpath)
require app_root + '/tt-analyzer-lib.rb'

class Timetrap::Formatters::Latest
  include TimeTrapAnalyzer
  
  def initialize(entries)
    @entries = entries
  end

  def output
    last_date = @entries[-1][:start].to_date
    "=== " + last_date.to_s + " ===" + day_summary(@entries.reject{ |entry| entry[:start].to_date != last_date })
  end
  
end