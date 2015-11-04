# encoding: utf-8
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

configure do
  # Load .env vars
  Dotenv.load
  # Disable output buffering
  $stdout.sync = true
end

Geocoder.configure(:lookup => :google, :api_key => ENV["GOOGLE_API_KEY"], :use_https => true)

get "/" do
  ""
end

post "/" do
  response['content-type'] = 'application/json'
  response = ""
begin
  puts "[LOG] #{params}"
  params[:text] = params[:text]
  unless params[:token] != ENV["OUTGOING_WEBHOOK_TOKEN"]
    response = { text: generate_text }
    response[:response_type] = "in_channel"
    response[:attachments] = [ generate_attachment ]
    response = response.to_json
  end
end
  status 200
  body response
end

def generate_request
  @user_query = params[:text]

  if @user_query.length == 0
    uri = "https://api.forecast.io/forecast/#{ENV["FORECAST_API_KEY"]}/#{ENV["DEFAULT_LATLON"]}"
  else
    locresults = Geocoder.coordinates("#{@user_query}")
    lat = locresults[0]
    lng = locresults[1]

    uri = "https://api.forecast.io/forecast/#{ENV["FORECAST_API_KEY"]}/#{lat},#{lng}"
  end

  request = HTTParty.get(uri)
  puts "[LOG] #{request.body}"
  result = JSON.parse(request.body)
end

def generate_emoji
  @currently = generate_request["currently"]
  currentIcon = @currently["icon"]
  if currentIcon == "clear-day"
  emoji = ":sunny:"
  elsif currentIcon = "clear-night"
  emoji = ":milky_way:"
  elsif currentIcon == "rain"
  emoji = ":umbrella:"
  elsif currentIcon == "snow"
  emoji = ":snowflake:"
  elsif currentIcon == "sleet"
  emoji = ":snowflake: :umbrella:"
  elsif currentIcon == "wind"
  emoji = ":dash:"
  elsif currentIcon == "fog"
  emoji = ":foggy:"
  elsif currentIcon == "cloudy"
  emoji = ":cloud:"
  elsif currentIcon == "partly-cloudy-day"
  emoji = ":partly_sunny:"
  elsif currentIcon == "partly-cloudy-night"
  emoji = ":cloud:"
  else
  emoji = ":partly_sunny:"
  end
end

def generate_text
  @currently = generate_request["currently"]
  currentSummary = @currently["summary"]
  currentTemp = @currently["temperature"]
  response = "It is #{currentTemp} degrees. #{currentSummary} #{generate_emoji}"
end

def generate_attachment
  @tomorrow = generate_request["daily"]
  tomorrowSummary = @tomorrow["summary"]
  response = { text: "#{tomorrowSummary}" }
end
