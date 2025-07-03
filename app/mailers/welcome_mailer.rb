# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  include Mailkick::UrlHelper
  LIST = 'welcome'

  def getting_most_out_of_postcard(account)
    return unless account.subscribed?(LIST)

    @account = account
    @unsubscribe_url = mailkick_unsubscribe_url(@account, LIST)

    mail subject: 'How to get the most out of Postcard', message_stream: :broadcast, to: @account.email do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def why_have_personal_website(account)
    return unless account.subscribed?(LIST)

    @account = account
    @unsubscribe_url = mailkick_unsubscribe_url(@account, LIST)

    mail subject: 'Benefits of a personal website', message_stream: :broadcast, to: @account.email do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def how_i_replaced_twitter(account)
    return unless account.subscribed?(LIST)

    @account = account
    @unsubscribe_url = mailkick_unsubscribe_url(@account, LIST)

    mail subject: 'How I replaced Twitter with a monthly newsletter', message_stream: :broadcast, to: @account.email,
         from: ActionMailer::Base.email_address_with_name('hello@postcard.page', 'Philip I. Thomas'),
         reply_to: 'philip@contraption.co' do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def cool_uses_for_personal_website(account)
    return unless account.subscribed?(LIST)

    @account = account
    @unsubscribe_url = mailkick_unsubscribe_url(@account, LIST)

    mail subject: 'Tips to make the most of a personal website', message_stream: :broadcast,
         to: @account.email do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def social_networks_over(account)
    return unless account.subscribed?(LIST)

    @account = account
    @unsubscribe_url = mailkick_unsubscribe_url(@account, LIST)

    mail subject: 'Why I built Postcard: A calmer alternative to social networks', message_stream: :broadcast,
         to: @account.email,
         from: ActionMailer::Base.email_address_with_name('hello@postcard.page', 'Philip I. Thomas'),
         reply_to: 'philip@contraption.co' do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  private

  def email_is_personal_domain
    return false if @account.email_domain == 'gmail.com'

    first_name = @account.first_name
    return true if @account.email_domain.include?(first_name.downcase)

    last_name = @account.last_name
    return true if last_name.present? && @account.email_domain.include?(last_name.downcase)

    false
  end

  def email_domain_is_online # rubocop:disable Metrics/MethodLength
    domain = @account.email_domain
    begin
      Timeout.timeout(5) do
        TCPSocket.new(domain, 'http').close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
        return false
      end
    rescue Timeout::Error
      false
    end
  end
end
