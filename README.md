# forecast-slack
### Slack slash command that uses forecast.io to generate current weather and a near future forecast

You can search for the weather in various locations by using zip codes

![example image 1](http://i.imgur.com/dK2ehKy.png)


You can also search by using landmarks, or other places of interest (powered by the Google Maps api)

![example image 2](http://i.imgur.com/iHJzQSn.png)


Or you can set a default location to just get the weather for your office.

![example image 3](http://i.imgur.com/xU8TeJi.png)


### What you will need
* A [Heroku](http://www.heroku.com) account
* A [Google Maps API key](https://developers.google.com/maps/documentation/geocoding/intro)
* A [forecast.io API key](https://developer.forecast.io/)
* A [slash command outgoing webhook token](https://api.slack.com/slash-commands) for your Slack team

### Setup
* Clone this repo locally
* Create a new Heroku app and initialize the repo
* Push the repo to Heroku
* Navigate to the settings page of the Heroku app and add the following config variables:
  * ```OUTGOING_WEBHOOK_TOKEN``` The token for your slash command integration in Slack
  * ```GOOGLE_API_KEY``` Your Google Maps API key
  * ```FORECAST_API_KEY``` Your forecast.io API key
  * ```DEFAULT_LATLON``` The default latitude and longitude for the bot (your home, your office, etc)
* Navigate to the integrations page for your Slack team. Create an slash command, use the URL for your heroku app, and copy the webhook token to your ```OUTGOING_WEBHOOK_TOKEN``` config variable. Give the command a name and a cool icon. That's it!
