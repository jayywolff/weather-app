class Forecast
  include ActiveModel::Model

  DETAILS = %i[query
               datetime
               location_name
               location_region
               zip_code
               current_temp_f
               current_temp_c
               min_temp_f
               max_temp_f
               min_temp_c
               max_temp_c
               condition
               icon
               cached_query].freeze

  attr_accessor(*DETAILS)

  validates :query, presence: true

  def cached_query?
    cached_query == true
  end
end
