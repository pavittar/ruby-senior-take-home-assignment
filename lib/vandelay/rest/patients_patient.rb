require 'vandelay/util/error_messages'
require 'vandelay/services/patients'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.before '/patients/:id' do
          return if params[:id] =~ /\A\d+\z/

          halt 400, {
            status_code: 400,
            status_message: ErrorMessages.message_for(:numeric_id_expected)
          }.to_json
        end

        app.get '/patients/:id' do
          result = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one(params[:id])

          return json(result) if result

          status 404
          json({
            status_code: 404,
            status_message: ErrorMessages.message_for(404)
          })
        end
      end

    end
  end
end
