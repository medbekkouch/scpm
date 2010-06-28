class Request < ActiveRecord::Base

  Wp_index = {
  "WP1.1 - Quality Control" => 0,
  "WP1.2 - Quality Assurance" => 4,
  "WP2 - Quality for Maintenance" => 8,
  "WP3 - Modeling" => 9,
  "WP4 - Surveillance" => 10,
  "WP4.2 - Surveillance Root cause" => 10,
  "WP5 - Change Accompaniment" => 11,
  "WP6.1 - Coaching PP" => 12,
  "WP6.2 - Coaching BRD" => 13
  }

  Comp_index = {
  "Easy" => 0,
  "Medium" => 1,
  "Difficult" => 2
  }

  Milestone_index = {
  "M1-M3" => 0,
  "M3-M5" => 1,
  "M5-M10" => 2,
  "Post-M10" => 3,
  "N/A" => 0,
  }

  #rows, cols = 8, 3
  #Loads = Array.new(rows) { Array.new(cols) }
  Loads = [
    # WP 1.1
    [4.5,5.25,7.75],
    [3.625,4.25,6],
    [2.875,3.875,6.5],
    [4.5,5.25,7.75],
    # WP 1.2
    [3.375,3.875,4.5],
    [6.125,7.75,10.375],
    [6,6.625,7.75],
    [6,7.75,10.25],
    # WP 2
    [5.75,8.625,13.25],
    # WP 3
    [9.5,18,25],
    # WP 4
    [6.125,8.5,13.5],
    # WP 5
    [11.875,25.75,47.25],
    # WP 6
    [5.25,12.5,23],
    [3.75,11.5,24],
    [2.25,6.5,16],
    [3,15,35],
    [8.75,13.25,18.25],
    # WP 1.1 CV
    [0.5,0.5,0.75],
    [1,1,1.5],
    [0.375,0.375,0.5],
    [2,2.5,3],
    # WP 1.2 CV
    [0.5,0.5,0.5],
    [2,2.5,3],
    [2,3,4],
    [3,4,5]]

  def wp_index(wp)
    rv = Wp_index[wp]
    raise "no workpackage #{wp}" if not rv
    rv
  end

  def milestone_index(m)
    rv = Milestone_index[m]
    raise "no milestone #{m}" if not rv
    rv
  end

  def comp_index(c)
    rv = Comp_index[c]
    raise "no complexity #{c}" if not rv
    rv
  end
  
  def workload
    return 0 if self.status == "cancelled" or self.status == "feedback"
    Loads[wp_index(self.work_package)+milestone_index(self.milestone)][comp_index(self.complexity)]
  end


  # calculate a start date based on the milestone date
  def gantt_start_date
    if self.start_date == ''
      if self.milestone_date != ''
        return (Time.parse(self.milestone_date) - real_duration.days).strftime("%Y-%m-%d")
      else
        return Date.new.strftime("%Y-%m-%d")
      end
    else
      return self.start_date
    end  
  end

  # taking into account the start date and the milestone date
  def real_duration
    if self.milestone_date != '' and self.start_date != ''
      days = (Time.parse(self.milestone_date) - Time.parse(self.start_date)) / 1.days
      return minus_week_ends(days)
    else
      return gantt_duration  
    end
  end

  def minus_week_ends(days)
   (days - ((days/7).to_i)*2).to_i
  end

  def rload
    real = real_duration
    real = 1 if real == 0
    return ((gantt_duration.to_f / real) * 100).to_i
  end

  def gantt_duration
    (self.workload+0.5).to_i
  end

end

