require 'app_helper'
require_relative '../../../../lib/vandelay/integrations/vendors/one'

describe Vandelay::Integrations::Vendors::One do
  let(:one) { described_class.new }
  let(:token) { '123456' }

  before(:each) do
    stub_request(:get, one.auth_url).
      to_return(status: 200, body: %Q({"token":"#{token}"}) )
  end

  describe '#authenticate' do
    it "does return authentication token" do
      expect(one.authenticate).to eq(token)
    end
  end

  describe '#all' do
    let(:expected_response) {
      [{
        patient_id: '743',
        province: 'QC',
        allergies: [
          'work',
          'conformity',
          'paying taxes'
        ],
        num_medical_visits: 1
      }]
    }

    let(:response) {
      JSON.dump(
        [{
          'id': '743',
          'full_name': 'Cosmo Kramer',
          'dob': '1987-03-18',
          'province': 'QC',
          'allergies': [
            'work',
            'conformity',
            'paying taxes'
          ],
          'recent_medical_visits': 1
        }]
      )
    }

    before do
      stub_request(:get, one.records_url).
        with(headers: {
          'Authorization' => "Bearer #{token}"
        }).
        to_return(status: 200, body: response )
    end

    it 'does return all records' do
      expect(one.all).to eq(expected_response)
    end

    it 'does pass Authorization header' do
      one.all

      expect(WebMock).to have_requested(:get, one.records_url)
        .with(headers: {
          'Authorization' => "Bearer #{token}"
        })
    end
  end

  describe '#find_by' do
    context 'when id is valid' do
      let(:id) { 743 }
      let(:record_url) { [one.records_url, '/', id].join }

      let(:expected_response) {
        {
          patient_id: '743',
          province: 'QC',
          allergies: [
            'work',
            'conformity',
            'paying taxes'
          ],
          num_medical_visits: 1
        }
      }

      let(:response) {
        JSON.dump(
          {
            'id': '743',
            'full_name': 'Cosmo Kramer',
            'dob': '1987-03-18',
            'province': 'QC',
            'allergies': [
              'work',
              'conformity',
              'paying taxes'
            ],
            'recent_medical_visits': 1
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
        expect(one.find_by(id: id)).to eq(expected_response)
      end

      it 'does pass Authorization header' do
        one.find_by(id: id)

        expect(WebMock).to have_requested(:get, record_url)
          .with(headers: {
            'Authorization' => "Bearer #{token}"
          })
      end
    end

    context 'when id is invalid' do
      let(:id) { 1 }
      let(:record_url) { [one.records_url, '/', id].join }

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
        expect(one.find_by(id: id)).to eq(expected_response)
      end

      it 'does pass Authorization header' do
        one.find_by(id: id)

        expect(WebMock).to have_requested(:get, record_url)
          .with(headers: {
            'Authorization' => "Bearer #{token}"
          })
      end
    end
  end
end