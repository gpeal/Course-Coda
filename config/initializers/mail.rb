mail_settings = YAML.load_file(Rails.root.join('config', 'mail.yml'))[Rails.env].symbolize_keys!
ActionMailer::Base.smtp_settings = mail_settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true