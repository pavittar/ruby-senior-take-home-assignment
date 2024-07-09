require 'vandelay/util/error_messages'
require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatientRecord
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.patient_records_srvc
        @patient_records_srvc ||= Vandelay::Services::PatientRecords.new
      end

      def self.registered(app)
        app.before '/patients/:id/record' do
          return if params[:id] =~ /\A\d+\z/

          halt 400, {
            status_code: 400,
            status_message: ErrorMessages.message_for(:numeric_id_expected)
          }.to_json
        end

        app.get '/patients/:id/record' do
          result = Vandelay::REST::PatientsPatientRecord.patients_srvc.retrieve_one(params[:id])

          halt 404, {
            status_code: 404,
            status_message: ErrorMessages.message_for(404)
          }.to_json if result.nil? || result.vendor_id.nil?

          record = Vandelay::REST::PatientsPatientRecord.patient_records_srvc.retrieve_record_for_patient(result)
          record.to_json
        end
      end

    end
  end
end
