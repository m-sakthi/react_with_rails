class SblogSettings < Settingslogic
  source "#{Rails.root}/config/sblog.yml"
  namespace Rails.env

  def self.build_url()
  	if ![443, 80].include?(port.to_i)
      custom_port = ":#{port}"
    else
      custom_port = nil
    end
    app_path =[ protocol, "://", host, custom_port, relative_url_root].join('')
  end
end

SblogSettings['host'] ||= 'localhost'
SblogSettings['relative_url_root'] ||= ''
SblogSettings['url'] ||= SblogSettings.build_url()

# SblogSettings['asset_host'] ||= Settingslogic.new({})
# SblogSettings['asset_host']['enabled'] ||= false
