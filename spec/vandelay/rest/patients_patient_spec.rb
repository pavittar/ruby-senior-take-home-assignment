require 'app_helper'
require_relative '../../../lib/vandelay/rest/patients_patient'

describe Vandelay::REST::PatientsPatient do
  describe 'GET /patients/:id' do
    context 'when record exists' do
      let(:id) { 1 }
      let(:expected_record) {{ "id" => "1", "full_name" => "Elaine Benes", "date_of_birth" => "1988-10-12", "records_vendor" => nil, "vendor_id" => nil }}

      it 'does return record' do
        get "/patients/#{id}"
        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)).to include(expected_record)
      end
    end

    context 'when record doesnot exists' do
      let(:id) { 10 }
      let(:expected_response) {{ "status_code" => 404, "status_message" => ErrorMessages.message_for(404) }}

      it 'does return error message' do
        get "/patients/#{id}"
        expect(last_response).to be_not_found
        expect(JSON.parse(last_response.body)).to include(expected_response)
      end
    end


    context 'when :id is not numeric' do
      let(:invalid_ids) { ['1abc', 'abc', '@#'] }
      let(:expected_response) {{ "status_code" => 400, "status_message" => ErrorMessages.message_for(:numeric_id_expected) }}

      it 'does return error message' do
        invalid_ids.each do |id|
          get "/patients/#{id}"
          expect(last_response).to be_bad_request
          expect(JSON.parse(last_response.body)).to include(expected_response)
        end
      end
    end
  end
end
