# frozen_string_literal: true

require 'active_support/concern'

module Verifiable
  extend ActiveSupport::Concern

  VERIFIER_ACTIVATION = 'activation'

  def verifier_for(verification_type)
    self.class.verifier.generate(id, purpose: verification_type)
  end

  class_methods do
    def from_verifier!(token, verification_type)
      id = verifier.verify(token, purpose: verification_type)
      find(id)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      raise ActiveRecord::RecordNotFound
    end

    def verifier
      @verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base)
    end
  end
end
