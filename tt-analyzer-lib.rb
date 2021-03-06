require 'time_difference'

class Hash 
  def reverse_sort_by_value
    Hash[sort_by{|k,v| -v}]
  end
end

class String
  def empty_or_spaces?
    strip.empty?
  end
end

class NilClass
  def empty_or_spaces?
    true
  end
end

module TimeTrapAnalyzer
  def day_summary(entries, print_acts=true, print_categories = true)
    activities = {}
    categories = {}
    activities.default = 0
    categories.default = 0

    entries.map do |entry|      
      entry[:end] = DateTime.current if !entry[:end]
      duration = TimeDifference.between(entry[:start], entry[:end]).in_minutes.round.to_i
      activities[entry[:note]] += duration

      cat_symbol = entry[:note][0]
      categories[cat_symbol] += duration
    end
    
    acts = activities.map do |key, val|
      activity_comment = key.split(" ")[1]
      sprintf("%s", key) unless activity_comment.empty_or_spaces? || activity_comment.start_with?("-")
    end.reject{|i| !i || i.strip.empty_or_spaces?}.join("\n")
    
    total = categories.values.inject(:+)

    cats = categories.reverse_sort_by_value.map do |category, duration|
      cat_name = CATEGORIES[category] || category
      format(cat_name, duration, total)
    end.join("\n")
    
    timing = cats + "\n-----\n" + format("Total", total)
    print_acts ? acts + "\n\n" + timing : timing
  end
  
  def format(cat_name, duration, total = nil)
    sprintf("%5s  %3s  %s", dur_to_s(duration), percent(duration, total), cat_name)
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
    "H" => "Other Activity",
    "R" => "Review",
    "T" => "Talks",
    "+" => "Development",
    "L" => "Self improvement"
  }
end