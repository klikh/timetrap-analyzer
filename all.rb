require 'pathname'
app_root = File.dirname(Pathname.new(__FILE__).realpath)
require app_root + '/tt-analyzer-lib.rb'

class Timetrap::Formatters::All
  include TimeTrapAnalyzer
  
  def initialize(entries)
    @entries = entries
  end
  
  def duration(entry)
    entry[:end] = DateTime.current if !entry[:end]
    return TimeDifference.between(entry[:start], entry[:end]).in_minutes.round.to_i
  end

  def output
    start_date = Date.new(2014, 12, 15) 
    
    summaries = []
    log = []
    log << "LOG"
    first_day = start_date
    last_day = start_date + 6.days
    week = 0
    while (last_day <= Date.current + 7) do
      times = []
      (first_day..last_day).each do |day|
        ents = @entries.select { |item| item[:start].to_date == day }
        day_time = ents.inject(0) { |accumulator, item| accumulator + duration(item) }
        times << day_time
      end
      sum = times.inject { |ac, i| ac + i }
      
      summaries << "\n"
      summaries << "WEEK ##{week} (#{first_day} - #{last_day})"
      summaries << "#{dur_to_s(sum)} == #{times.map{|it| dur_to_s(it)}.join(' + ')}"
      
      first_day += 7.days
      last_day += 7.days
      week += 1
    end
    
    return summaries
  end
  
end
