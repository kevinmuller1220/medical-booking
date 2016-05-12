module Users::PatientsHelper
  def formatted_time(time, ampm = false)
    if ampm
      time.getlocal.strftime("%l:%M %p")
    else
      time.getlocal.strftime("%H:%M")
    end
  end
  
  def formatted_date(date)
    date.strftime("%-d %b %Y")
  end
end
