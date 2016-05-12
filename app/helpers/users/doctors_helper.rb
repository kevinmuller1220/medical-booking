module Users::DoctorsHelper
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

  def excerpt(text, length = 150)
    if text.present?
      strip_tags(text)[0..length] << '...'
    else
      ''
    end
  end
end
