require 'app_helper'
require_relative '../../../../lib/vandelay/integrations/vendors/two'

describe Vandelay::Integrations::Vendors::Two do
  let(:two) { described_class.new }
  let(:token) { '123456' }

  before(:each) do
    stub_request(:get, two.auth_url).
      to_return(status: 200, body: %Q({"token":"#{token}"}) )
  end

  describe '#authenticate' do
    it "does return authentication token" do
      expect(two.authenticate).to eq(token)
    end
  end

  describe '#all' do
    let(:expected_response) {
      [{
        patient_id: '16',
        province: 'ON',
        allergies: [
          "hair",
          "mean people",
          "paying the bill"
        ],
        num_medical_visits: 17
      }]
    }

    let(:response) {
      JSON.dump(
        [{
          "id": "16",
          "name": "George Costanza",
          "birthdate": "1984-09-07",
          "province_code": "ON",
          "clinic_id": "7",
          "allergies_list": [
            "hair",
            "mean people",
            "paying the bill"
          ],
          "medical_visits_recently": 17
        }]
      )
    }

    before do
      stub_request(:get, two.records_url).
        with(headers: {
          'Authorization' => "Bearer #{token}"
        }).
        to_return(status: 200, body: response )
    end

    it 'does return all records' do
      expect(two.all).to eq(expected_response)
    end

    it 'does pass Authorization header' do
      two.all

      expect(WebMock).to have_requested(:get, two.records_url)
        .with(headers: {
          'Authorization' => "Bearer #{token}"
        })
    end
  end

  describe '#find_by' do
    context 'when id is valid' do
      let(:id) { 743 }
      let(:record_url) { [two.records_url, '/', id].join }

      let(:expected_response) {
        {
          patient_id: '16',
          province: 'ON',
          allergies: [
            "hair",
            "mean people",
            "paying the bill"
          ],
          num_medical_visits: 17
        }
      }

      let(:response) {
        JSON.dump(
          {
            "id": "16",
            "name": "George Costanza",
            "birthdate": "1984-09-07",
            "province_code": "ON",
            "clinic_id": "7",
            "allergies_list": [
              "hair",
              "mean people",
              "paying the bill"
            ],
            "medical_visits_recently": 17
          }
        )
      }

      before do
        stub_request(:get, record_url).
          with(headers: {
            'Authorization' => "Bearer #{token}"
          }).
          to_return(status: 200, body: response )
      end

      it 'does return requested record' do
        expect(two.find_by(id: id)).to eq(expected_response)
      end

      it 'does pass Authorization header' do
        two.find_by(id: id)

        expect(WebMock).to have_requested(:get, record_url)
          .with(headers: {
            'Authorization' => "Bearer #{token}"
          })
      end
    end

    context 'when id is invalid' do
      let(:id) { 1 }
      let(:record_url) { [two.records_url, '/', id].join }

      let(:expected_response) {
        {}
      }

      let(:response) {
        JSON.dump({})
      }

      before do
        stub_request(:get, record_url).
          with(headers: {
            'Authorization' => "Bearer #{token}"
          }).
          to_return(status: 200, body: response )
      end

      it 'does return requested record' do
        expect(two.find_by(id: id)).to eq(expected_response)
      end

      it 'does pass Authorization header' do
        two.find_by(id: id)

        expect(WebMock).to have_requested(:get, record_url)
          .with(headers: {
            'Authorization' => "Bearer #{token}"
          })
      end
    end
  end
end