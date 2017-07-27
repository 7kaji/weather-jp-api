#! /usr/bin/env ruby

require 'json'
require 'yaml'
require 'bundler'
Bundler.require

class App < Sinatra::Base
  set :server, :puma
  WEATHER_API_HOST = 'http://weather.livedoor.com'
  WEATHER_API_PATH = '/forecast/webservice/json/v1'

  before do
    @japan = YAML.load_file('japan.yml')
    content_type :json
  end

  get '/api/v1/japan' do
    @japan.keys.to_json
  end

  get '/api/v1/:pref' do
    cache_control :public, max_age: 3600  # 1 hour.

    pref = params[:pref].to_sym
    return status 404 unless @japan.include?(pref)

    data = {}
    @japan[pref].each do |city, no|
      data.merge!({ city => JSON.parse(Faraday.new(url: WEATHER_API_HOST).get("#{WEATHER_API_PATH}?city=#{no}").body).to_h })
    end
    data.to_json
  end
end
