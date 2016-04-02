module ApplicationHelper

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name # :user
  end

  def resource_class
    devise_mapping.to
  end

  def auth_user
    current_user || current_doctor_user || current_patient_user
  end

  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CAL'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

  def working_days
    [
      ['Monday'],
      ['Thuesday'],
      ['Wednesday'],
      ['Thursday'],
      ['Friday'],
      ['Saturday'],
      ['Sunday']
    ]
  end

  def account_path
    if auth_user.doctor?
      doctor_path(auth_user)
    elsif auth_user.patient?
      patient_path(auth_user)
    end
  end

  def settings_path
    if auth_user.doctor?
      edit_doctor_path(auth_user)
    elsif auth_user.patient?
      edit_patient_path(auth_user)
    end
  end

  def navbar_logo
    if auth_user.avatar.exists?
      image_tag(auth_user.avatar(:thumb), class: 'img-circle', alt: auth_user.full_name)
    else
      image_tag('thumb/missing.png', class: 'img-circle', alt: 'missing')
    end
  end

  def alert_type(key)
    puts 'alert-type' << key
    case key
    when 'error'
      'danger'
    else
      'info'
    end
  end

  def specialities_collection
    Speciality.all.collect{ |s| [ s.name, s.id ] }
  end

  def omniauth_providers
    {
      'google_oauth2': 'Google',
      'facebook': 'Facebook'
    }
  end
end
