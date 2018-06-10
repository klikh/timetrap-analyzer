require 'pathname'
app_root = File.dirname(Pathname.new(__FILE__).realpath)
require app_root + '/tt-analyzer-lib.rb'

class Timetrap::Formatters::Allstat
  include TimeTrapAnalyzer
  
  def initialize(entries)
    @entries = entries
  end

  def output
    first_day = @entries[0][:start].to_date
    last_day = @entries[-1][:start].to_date
    range = "=== #{first_day} -> #{last_day} ===\n\n"
    range + day_summary(@entries, false)
  end
  
end