require_relative '../integrations/vendors/one'
require_relative '../integrations/vendors/two'
require_relative '../util/cache.rb'

module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient)
        cache_key = ['vendor', patient.records_vendor, patient.vendor_id].join('-')

        cache_store.fetch(cache_key) do
          gateway(patient)
            .find_by(id: patient.vendor_id)
        end
      end

      def gateway(patient)
        begin
          Vandelay::Integrations::Vendors.const_get(patient.records_vendor.capitalize).new
        rescue => e
          raise ArgumentError, 'Unknown Vendor'
        end
      end

      def cache_store
        @cache_store ||= Vandelay::Util::Cache.new
      end
    end
  end
end