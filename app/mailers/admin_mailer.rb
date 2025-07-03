# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  default from: -> { ActionMailer::Base.email_address_with_name('admin@postcard.page', 'Postcard') },
          to: -> { 'mail@philipithomas.com' }

  def new_account
    @account = params[:account]

    return unless Rails.env.production?

    subject = "New Postcard: #{@account.host}"
    subject = "Activated Postcard: #{@account.host}" if @account.source_printer?

    mail subject: subject, reply_to: @account.email do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def activation_visit
    @account = params[:account]

    subject = "New activation link visit: #{@account.email} - #{@account.host}"

    mail subject: subject do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def new_feedback(feedback)
    @feedback = feedback

    mail subject: "Postcard feedback from #{@feedback.account.name}", to: 'postcard@contraption.co',
         from: 'Postcard Feedback <feedback@postcard.page>', reply_to: @feedback.account.email do |format|
      format.html { render }
    end
  end

  def new_subscribers_import_request(subscribers_import)
    @subscribers_import = subscribers_import
    mail subject: "Subscriber import request from #{@subscribers_import.account.email}",
         reply_to: @subscribers_import.account.email, to: 'postcard@contraption.co' do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  # visits_in_last_day has been migrated to PostInAdminChatJob.
end
