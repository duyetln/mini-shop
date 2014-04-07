class Status < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  validates :owner, presence: true
  validates :status, presence: true

  default_scope { order(:created_at) }

  module Mixin
    extend ActiveSupport::Concern

    included do

      has_many :statuses, as: :owner, class_name: 'Status'

      self::STATUS.each do |key, value|
        class_eval <<-EOF
          def #{key}?
            status && status.status == #{value}
          end

          def mark_#{key}!
            status = ::Status.new
            status.owner = self
            status.status = #{value}
            status.save! && status
          end
        EOF
      end
    end

    def status
      statuses.last
    end

    def marked?
      status.present?
    end

    def unmarked?
      !marked?
    end
  end
end
