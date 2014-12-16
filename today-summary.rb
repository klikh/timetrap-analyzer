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
    
    acts = activities.map { |key, val| sprintf("%s", key) }.join("\n")
    
    cats = categories.reverse_sort_by_value.map do |category, duration|
      cat_name = CATEGORIES[category] || category
      format(cat_name, duration)
    end.join("\n")

    total = categories.values.inject(:+)
    
    acts + "\n\n" + cats + "\n-----\n" + format("Total", total)
  end
  
  def format(cat_name, duration)
    sprintf("%5s  %s", dur_to_s(duration), cat_name)
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