require 'app_helper'
require_relative '../../../lib/vandelay/services/patient_records'
require_relative '../../../lib/vandelay/models/patient'
require_relative '../../../lib/vandelay/util/cache'

describe Vandelay::Services::PatientRecords do
  describe '#retrieve_record_for_patient' do
    let(:record) { Vandelay::Models::Patient.new(records_vendor: "one", vendor_id: "743") }
    let(:instance) { described_class.new }
    let(:gateway) { instance.gateway(record) }

    before do
      Vandelay::Util::Cache.new.flush!
      allow(instance).to receive(:gateway).and_return(gateway)
    end

    it "does call #gateway accordingly" do
      expect(gateway).to receive(:find_by).with(id: record.vendor_id)
      instance.retrieve_record_for_patient(record)

      # cached
      expect(gateway).not_to receive(:find_by)
      instance.retrieve_record_for_patient(record)
    end
  end

  describe '#gateway' do
    context 'when record vendor is one' do
      let(:instance) { described_class.new }
      let(:record) { Vandelay::Models::Patient.new(records_vendor: "one", vendor_id: "743") }
      let(:gateway) { instance.gateway(record) }

      it "does select correct vendor gateway" do
        expect(gateway).to be_instance_of(Vandelay::Integrations::Vendors::One)
      end
    end

    context 'when record vendor is two' do
      let(:instance) { described_class.new }
      let(:record) { Vandelay::Models::Patient.new(records_vendor: "two", vendor_id: "16") }
      let(:gateway) { instance.gateway(record) }

      it "does select correct vendor gateway" do
        expect(gateway).to be_instance_of(Vandelay::Integrations::Vendors::Two)
      end
    end

    context 'when record vendor is unknown' do
      let(:instance) { described_class.new }
      let(:record) { Vandelay::Models::Patient.new(records_vendor: "three", vendor_id: "1") }
      let(:gateway) { instance.gateway(record) }

      fit "does raise ArgumentError" do
        expect{ gateway }.to raise_error(ArgumentError)
      end
    end
  end
end