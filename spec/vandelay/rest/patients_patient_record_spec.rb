require 'app_helper'
require_relative '../../../lib/vandelay/rest/patients_patient_record'

describe Vandelay::REST::PatientsPatientRecord do
  describe 'GET /patients/:id/record' do
    context 'when record exists' do
      let(:id) { 2 }
      let(:expected_record) {{"patient_id" => "743", "province" => "QC", "allergies" => [], "num_medical_visits" => 1 }}

      before do
        allow(described_class.patient_records_srvc).
          to receive(:retrieve_record_for_patient).
          and_return(expected_record)
      end

      it 'does return record' do
        get "/patients/#{id}/record"
        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)).to eq(expected_record)
      end
    end

    context 'when record doesnot exists' do
      let(:id) { 10 }
      let(:expected_response) {{ "status_code" => 404, "status_message" => ErrorMessages.message_for(404) }}

      it 'does return error message' do
        get "/patients/#{id}/record"
        expect(last_response).to be_not_found
        expect(JSON.parse(last_response.body)).to eq(expected_response)
      end
    end

    context 'when vendor id is nil'
      let(:id) { 1 }
      let(:expected_response) {{ "status_code" => 404, "status_message" => ErrorMessages.message_for(404) }}

      it 'does return error message' do
        get "/patients/#{id}/record"
        expect(last_response).to be_not_found
        expect(JSON.parse(last_response.body)).to include(expected_response)
      end
    end

    context 'when :id is not numeric' do
      let(:invalid_ids) { ['1abc', 'abc', '@#'] }
      let(:expected_response) {{ "status_code" => 400, "status_message" => ErrorMessages.message_for(:numeric_id_expected) }}

      it 'does return error message' do
        invalid_ids.each do |id|
          get "/patients/#{id}/record"
          expect(last_response).to be_bad_request
          expect(JSON.parse(last_response.body)).to include(expected_response)
        end
      end
    end
  end