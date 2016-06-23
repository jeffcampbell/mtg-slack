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
  unless generate_request[0].nil?
    @cardname = generate_request[0]["name"]
    response = "#{@cardname}"
  end
  response
end

def generate_attachment
  replacements = [ ["{W}", ":white_circle:"], ["{U}", ":large_blue_circle:"],["{B}", ":black_circle:"],["{R}", ":red_circle:"],["{G}", ":tennis:"],["{", ""],["}", ""] ]
  unless generate_request[0].nil?
  @cardtext = generate_request[0]["text"]
  @imageurl = generate_request[0]["editions"][0]["image_url"]
  @types = generate_request[0]["types"][0]
  @cost = generate_request[0]["cost"]

  replacements.each {|replacement| @cost.gsub!(replacement[0], replacement[1])}
  replacements.each {|replacement| @cardtext.gsub!(replacement[0], replacement[1])}

  response = {
            text: "#{@cardtext}",
            fields: [
                {
                    "title": "Types",
                    "value": "#{@types}",
                    "short": true
                },
                {
                    "title": "Cost",
                    "value": "#{@cost}",
                    "short": true
                },
            ],
            image_url: "#{@imageurl}" }
  end
response
end
