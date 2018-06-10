require 'pathname'
app_root = File.dirname(Pathname.new(__FILE__).realpath)
require app_root + '/tt-analyzer-lib.rb'

class Timetrap::Formatters::Top
  include TimeTrapAnalyzer
  
  def initialize(entries)
    @entries = entries
  end
  
  def duration(entry)
    entry[:end] = DateTime.current if !entry[:end]
    return TimeDifference.between(entry[:start], entry[:end]).in_minutes.round.to_i
  end

  def output
    start_date = Date.new(2014, 12, 21) 
    
    log = []
    log << "LOG"
    first_day = start_date
    last_day = start_date + 6.days
    week = 0
    weeks = []
    while (last_day <= Date.current + 7) do
      times = []
      (first_day..last_day).each do |day|
        ents = @entries.select { |item| item[:start].to_date == day }
        day_time = ents.inject(0) { |accumulator, item| accumulator + duration(item) }
        times << day_time
      end
      sum = times.inject { |ac, i| ac + i }
      
      summary = []
      summary << "\n"
      summary << "WEEK ##{week} (#{first_day} - #{last_day})"
      summary << "#{dur_to_s(sum)} == #{times.map{|it| dur_to_s(it)}.join(' + ')}"
      
      weeks << Week.new(sum, week, first_day, last_day, summary)
      
      first_day += 7.days
      last_day += 7.days
      week += 1
    end
    
    weeks = weeks.sort_by {|week| week.sum}
    return weeks.map {|week| week.summary}
  end
  
end

class Week
  attr_accessor :sum, :summary
  def initialize(sum, week, first_day, last_day, summary)  
      @sum = sum
      @week = week
      @first_day = first_day
      @last_day = last_day
      @summary = summary
    end  
end
