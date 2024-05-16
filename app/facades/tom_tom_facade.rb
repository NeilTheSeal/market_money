class TomTomFacade
  def self.nearest_atms(lat, lon)
    params  = { lon: lon, lat: lat, language: 'en-US', categorySet: 7397 }
    results = TomTomService.call_db('/search/2/nearbySearch/.json', params)[:results]
    results.map { |atm| Atm.new(atm) }.sort_by(&:distance)
  end
end