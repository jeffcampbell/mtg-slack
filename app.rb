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
  @user_query = params[:text].gsub(/\s/,'+')

  if @user_query.length == 0
    uri = "https://api.deckbrew.com/mtg/colors"
  else
    uri = "https://api.deckbrew.com/mtg/cards?name=#{@user_query}"
  end

  request = HTTParty.get(uri)
  puts "[LOG] #{request.body}"
  result = JSON.parse(request.body)
end

def generate_text
  @cardname = generate_request[0]["name"]
  response = "#{@cardname}"
end

def generate_attachment
  @cardtext = generate_request[0]["text"]
  @imageurl = generate_request[0]["editions"][0]["image_url"]
  response = { text: "#{@cardtext} #{@imageurl}" }
end
