module Users::PatientsHelper
  def formatted_time(time, ampm = false)
    if ampm
      time.strftime("%l:%M %p")
    else
      time.strftime("%H:%M")
    end
  end
  
  def formatted_date(date)
    date.strftime("%-d %b %Y")
  end
end
