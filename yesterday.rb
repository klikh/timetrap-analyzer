require 'pathname'
app_root = File.dirname(Pathname.new(__FILE__).realpath)
require app_root + '/tt-analyzer-lib.rb'

class Timetrap::Formatters::Yesterday 
  include TimeTrapAnalyzer
  
  def initialize(entries)
    @entries = entries
  end

  def output
    ents = @entries.reject{ |entry| entry[:start].to_date != Date.current-1 }
    day_summary(ents)
  end
  
end