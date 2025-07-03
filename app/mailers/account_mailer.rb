# frozen_string_literal: true

class AccountMailer < ApplicationMailer # rubocop:disable Metrics/ClassLength
  include Mailkick::UrlHelper

  default to: -> { @subscription ? @subscription.email_address.email : nil },
          from: lambda {
                  if Rails.application.config.solo_mode
                    ActionMailer::Base.email_address_with_name(
                      Rails.application.config.default_email_from,
                      Rails.application.config.default_email_from_name
                    )
                  elsif @subscription
                    account_address(@account)
                  else
                    ActionMailer::Base.email_address_with_name(
                      Rails.application.config.default_email_from,
                      Rails.application.config.default_email_from_name
                    )
                  end
                },
          reply_to: -> { Rails.application.config.default_email_reply_to }

  utm_params

  has_history user: -> { @subscription ? @subscription.email_address : @account },
              extra: lambda {
                       {
                         account_id: @account.id,
                         subscription_id: @subscription ? @subscription.id : nil,
                         post_id: @post ? @post.id : nil,
                         unsubscribe_token: @unsubscribe_token || nil
                       }
                     }

  def account_details(account)
    @account = account
    mail subject: 'Your Postcard account details', to: @account.email do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def subscription_verification(subscription)
    @subscription = subscription
    @account = subscription.account

    @verification_url = subscription_verification_url(@subscription, token: @subscription.verification_token,
                                                                     :host => @account.host)
    mail subject: "Please confirm your subscription to #{@account.name.possessive} mailing list" do |format|
      format.html { render layout: 'mail/account' }
    end
  end

  def new_subscriber(subscription)
    @subscription = subscription
    @account = subscription.account

    if Rails.application.config.solo_mode
      from_address = ActionMailer::Base.email_address_with_name(
        Rails.application.config.default_email_from,
        Rails.application.config.default_email_from_name
      )
    else
      domain = Rails.application.config.default_email_from.split('@').last
      address = Mail::Address.new "#{@account.slug}+new-subscriber@#{domain}" # ex: "john@example.com"
      address.display_name = Rails.application.config.default_email_from_name # ex: "John Doe"
      from_address = address.format # returns "John Doe <john@example.com>"
    end

    mail subject: "New subscriber: #{@subscription.email_address.email}", to: @account.email, from: from_address,
         bcc: nil do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def new_post(post, subscription)
    @unsubscribe_token = SecureRandom.uuid
    @post = post
    @subscription = subscription
    @account = post.account

    mail subject: @post.subject, message_stream: :broadcast, reply_to: @account.email do |format|
      format.html { render layout: 'mail/account' }
    end
  end

  def domain_verified(account)
    @account = account
    mail subject: "Your domain is live: #{@account.host}", to: @account.email do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  ANALYTICS_SUMMARY_LIST = 'analytics_summary'
  def analytics_summary(account) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return unless account.subscribed?(ANALYTICS_SUMMARY_LIST)

    @account = account

    @unsubscribe_url = mailkick_unsubscribe_url(@account, ANALYTICS_SUMMARY_LIST)

    from = 1.week.ago
    to = Time.zone.now

    @visitor_count = account.page_visits(from: from, to: to).distinct.count(:visit_id)
    @view_count = account.page_visits(from: from, to: to).distinct.count(:id)
    @most_visited = account.page_visits(from: from, to: to) \
                           .select("properties #>> '{canonical_url}' as url, count(distinct id) as views") \
                           .group("properties #>> '{canonical_url}'") \
                           .order('views DESC')
                           .limit(5)

    @referrers = account.page_visits(from: from, to: to) \
                        .joins('INNER JOIN ahoy_visits ON ahoy_visits.id=ahoy_events.visit_id') \
                        .select(
                          'substring(ahoy_visits.referrer from \'(?:.*://)?(?:www\.)?([^/?]*)\') as referrer_domain,' \
                          'count(distinct ahoy_visits.id) as visitors'
                        ) \
                        .group('referrer_domain') \
                        .order('visitors DESC') \
                        .where.not(ahoy_visits: { referrer: nil }) \
                        .limit(5) \
                        .distinct(:ahoy_visit_id)

    if @visitor_count <= 1
      logger.info "Skipping analytics summary for #{account.host} because visitor count was #{@visitor_count}"
      return
    end

    mail subject: "#{ActionController::Base.helpers.number_to_human(@visitor_count)} people visited #{@account.pretty_host} last week", # rubocop:disable Layout/LineLength
         to: @account.email do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  def subscribers_import_approved(subscribers_import)
    @subscribers_import = subscribers_import
    @account = subscribers_import.account
    mail subject: "Subscribers imported to #{@account.name}", to: @account.email do |format|
      format.html { render layout: 'mail/transactional' }
    end
  end

  private

  def account_address(account)
    if Rails.application.config.solo_mode
      return Rails.application.config.default_email_from
    end

    # Extract domain from the configured DEFAULT_EMAIL_FROM
    domain = Rails.application.config.default_email_from.split('@').last
    address = Mail::Address.new "#{account.slug}@#{domain}" # ex: "john@example.com"
    address.display_name = account.name.dup # ex: "John Doe"
    address.format # returns "John Doe <john@example.com>"
  end
end
