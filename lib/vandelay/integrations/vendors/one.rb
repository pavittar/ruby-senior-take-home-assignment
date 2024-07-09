require_relative './base'

module Vandelay
  module Integrations
    module Vendors
      class One < Vandelay::Integrations::Vendors::Base
        def initialize
          @base_url = Vandelay.config.dig('integrations', 'vendors', 'one', 'api_base_url')

          @auth_url    = ['http://', base_url, '/auth/1'].join
          @records_url = ['http://', base_url, '/patients'].join

          @auth_token   = nil
        end

      private
        def record_mapper(record)
          {
            patient_id:         record['id'],
            province:           record['province'],
            allergies:          record['allergies'],
            num_medical_visits: record['recent_medical_visits']
          }
        end
      end
    end
  end
end