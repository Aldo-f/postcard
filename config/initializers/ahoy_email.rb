# frozen_string_literal: true

AhoyEmail.default_options[:message] = true
AhoyEmail.message_model = -> { EmailMessage }

AhoyEmail.default_options[:message] = true

AhoyEmail.save_token = true
AhoyEmail.subscribers << AhoyEmail::DatabaseSubscriber
AhoyEmail.api = true
