require 'time_difference'

class Hash 
  def reverse_sort_by_value
    Hash[sort_by{|k,v| -v}]
  end
end


class Timetrap::Formatters::Today
  def initialize(entries)
    @entries = entries
  end

  def output
    activities = {}
    categories = {}
    activities.default = 0
    categories.default = 0
    @entries.map do |entry|
      next if entry[:end].to_date != Date.current
      
      duration = TimeDifference.between(entry[:start], entry[:end]).in_minutes.round.to_i
      activities[entry[:note]] += duration

      cat_symbol = entry[:note][0]
      categories[cat_symbol] += duration
    end
    
    acts = activities.map do |key, val|
      sprintf("%s", key) unless key.split(" ")[1].start_with?("-")
    end.reject{|i| !i || i.strip.empty?}.join("\n")
    
    total = categories.values.inject(:+)

    cats = categories.reverse_sort_by_value.map do |category, duration|
      cat_name = CATEGORIES[category] || category
      format(cat_name, duration, total)
    end.join("\n")
    
    acts + "\n\n" + cats + "\n-----\n" + format("Total", total)
  end
  
  def format(cat_name, duration, total = nil)
    sprintf("%5s  %2s  %s", dur_to_s(duration), percent(duration, total), cat_name)
  end
  
  def percent(duration, total)
    total == nil ? "   " : (100 * duration / total.to_f).round.to_s + "%"
  end
  
  def dur_to_s(duration)
    hours = duration / 60
    minutes = duration % 60
    (hours > 0 ? "#{hours}h" : "") + minutes.to_s + "m"
  end
  
  CATEGORIES = {
    "S" => "Support",
    "R" => "Review",
    "T" => "Talks",
    "B" => "Self Fixing",
    "+" => "Productive"
  }
  
end