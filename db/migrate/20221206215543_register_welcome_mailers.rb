# frozen_string_literal: true

class RegisterWelcomeMailers < ActiveRecord::Migration[7.0]
  def change
    Account.where(source: :signup).find_each(batch_size: 100) do |account|
      account.subscribe(WelcomeMailer::LIST)

      jitter = rand(8.hours)

      WelcomeMailer.how_i_replaced_twitter(account).deliver_later(wait: jitter)
      WelcomeMailer.social_networks_over(account).deliver_later(wait: (2.days + jitter))
    end
  end
end
