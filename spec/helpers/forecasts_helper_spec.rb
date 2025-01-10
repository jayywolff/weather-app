require 'rails_helper'

RSpec.describe ForecastsHelper, type: :helper do
  describe '#temperature_icon(temperature)' do
    subject { helper.temperature_icon(temperature) }

    context 'when temperature is blank' do
      let(:temperature) { '' }

      it { is_expected.to eq 'thermometer' }
    end

    context 'when temperature is below 20°(F)' do
      let(:temperature) { 19 }

      it { is_expected.to eq 'thermometer-snow' }
    end

    context 'when temperature is between 20-40°(F)' do
      let(:temperature) { 20.1 }

      it { is_expected.to eq 'thermometer-low' }
    end

    context 'when temperature is between 40-74°(F)' do
      let(:temperature) { 73 }

      it { is_expected.to eq 'thermometer-half' }
    end

    context 'when temperature is between 74-90°(F)' do
      let(:temperature) { 75 }

      it { is_expected.to eq 'thermometer-high' }
    end

    context 'when temperature is 90°(F)' do
      let(:temperature) { 90 }

      it { is_expected.to eq 'thermometer-sun' }
    end

    context 'when temperature is above 90°(F)' do
      let(:temperature) { 90.1 }

      it { is_expected.to eq 'thermometer-sun' }
    end
  end
end
