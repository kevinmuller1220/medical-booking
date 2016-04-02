module DatepickerHelper
  def datepicker_helper field, value, id=''
    # parsed_value = if value.blank?
    #   Date.today.strftime("%m/%d/%y")
    # else
    #   value
    # end
    text_field_tag field.to_sym, value, placeholder: "Date", id: id, class: 'form-control input-arrow datepicker'
  end
end
