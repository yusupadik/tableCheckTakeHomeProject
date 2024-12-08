class CompetitorPricingService
  include HTTParty

  BASE_URL = "#{ENV["COMPETITOR_HOST"]}/prices?api_key=#{ENV["COMPETITOR_APIKEY"]}"
  MAX_RETRIES = ENV["MAX_RETRIES"] || 3
  RETRY_DELAY_IN_SECOND = ENV["RETRY_DELAY_IN_SECOND"] || 5

  def self.fetch_prices
    retries = 0

    begin
      response = get(BASE_URL)
      if response.success?
        response.parsed_response
      else
        raise "Failed to fetch competitor prices"
      end
    rescue => error
      # retry mechanism if the API call failed
      retries += 1
      Rails.logger.error "Attempt #{retries} failed: #{error.message}"

      if retries < MAX_RETRIES.to_i
        Rails.logger.info "Retrying in #{RETRY_DELAY_IN_SECOND} seconds..."
        sleep(RETRY_DELAY_IN_SECOND.to_i)
        retry
      else
        Rails.logger.error "All #{MAX_RETRIES} attempts failed. Returning empty result."
        []
      end
    end
  end
end