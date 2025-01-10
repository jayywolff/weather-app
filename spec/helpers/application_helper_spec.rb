require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#format_datetime(datetime, weekday: false)' do
    subject(:result) { helper.format_datetime(datetime) }

    let(:datetime) { Time.find_zone('Eastern Time (US & Canada)').parse('2025-01-09 15:01:01') }

    context 'default happy path' do
      it 'returns a date time string formatted without the weekday' do
        expect(result).to eq 'January 9th, 2025 3:01 PM'
      end
    end

    context 'when datetime is blank' do
      let(:datetime) { '' }

      it { is_expected.to eq '' }
    end

    context 'when datetime is nil' do
      let(:datetime) { nil }

      it { is_expected.to eq '' }
    end

    context 'when weekday param is false' do
      subject(:result) { helper.format_datetime(datetime, weekday: false) }

      it 'returns a date time string formatted without the weekday' do
        expect(result).to eq 'January 9th, 2025 3:01 PM'
      end
    end

    context 'when weekday param is true' do
      subject(:result) { helper.format_datetime(datetime, weekday: true) }

      it 'returns a date time string formatted with the weekday prefix' do
        expect(result).to eq 'Thursday January 9th, 2025 3:01 PM'
      end
    end
  end

  describe '#flash_bootstrap_alert_type(type)' do
    subject { helper.flash_bootstrap_alert_type(type) }

    context 'when type is blank' do
      let(:type) { '' }

      it { is_expected.to eq 'alert-info' }
    end

    context 'when type is alert' do
      let(:type) { 'alert' }

      it { is_expected.to eq 'alert-danger' }
    end

    context 'when type is danger' do
      let(:type) { 'danger' }

      it { is_expected.to eq 'alert-danger' }
    end

    context 'when type is error' do
      let(:type) { 'error' }

      it { is_expected.to eq 'alert-danger' }
    end

    context 'when type is notice' do
      let(:type) { 'notice' }

      it { is_expected.to eq 'alert-success' }
    end

    context 'when type is success' do
      let(:type) { 'success' }

      it { is_expected.to eq 'alert-success' }
    end
  end

  describe '#flash_bootstrap_icon(type)' do
    subject { helper.flash_bootstrap_icon(type) }

    context 'when type is blank' do
      let(:type) { '' }

      it { is_expected.to eq 'exclamation-circle' }
    end

    context 'when type is alert' do
      let(:type) { 'alert' }

      it { is_expected.to eq 'exclamation-triangle-fill' }
    end

    context 'when type is danger' do
      let(:type) { 'danger' }

      it { is_expected.to eq 'exclamation-triangle-fill' }
    end

    context 'when type is error' do
      let(:type) { 'error' }

      it { is_expected.to eq 'exclamation-triangle-fill' }
    end

    context 'when type is notice' do
      let(:type) { 'notice' }

      it { is_expected.to eq 'check-circle' }
    end

    context 'when type is success' do
      let(:type) { 'success' }

      it { is_expected.to eq 'check-circle' }
    end
  end
end
