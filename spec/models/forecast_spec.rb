require 'rails_helper'

RSpec.describe Forecast, type: :model do
  it { is_expected.to be_a_kind_of ActiveModel::Model }

  describe 'validations' do
    it { is_expected.to validate_presence_of :query }
  end
end
