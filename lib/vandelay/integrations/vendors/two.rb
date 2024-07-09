require_relative './base'

module Vandelay
  module Integrations
    module Vendors
      class Two < Vandelay::Integrations::Vendors::Base
        def initialize
          @base_url = Vandelay.config.dig('integrations', 'vendors', 'two', 'api_base_url')

          @auth_url    = ['http://', base_url, '/auth_tokens/1'].join
          @records_url = ['http://', base_url, '/records'].join

          @auth_token   = nil
        end

      private
        def record_mapper(record)
          {
            patient_id:         record['id'],
            province:           record['province_code'],
            allergies:          record['allergies_list'],
            num_medical_visits: record['medical_visits_recently']
          }
        end
      end
    end
  end
end