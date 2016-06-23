# mtg-slack
### Slack slash command that retrieves Magic: The Gathering card information

### What you will need
* A [Heroku](http://www.heroku.com) account
* A [slash command outgoing webhook token](https://api.slack.com/slash-commands) for your Slack team

### Setup
* Clone this repo locally
* Create a new Heroku app and initialize the repo
* Push the repo to Heroku
* Navigate to the settings page of the Heroku app and add the following config variables:
  * ```OUTGOING_WEBHOOK_TOKEN``` The token for your slash command integration in Slack
* Navigate to the integrations page for your Slack team. Create an slash command, use the URL for your heroku app, and copy the webhook token to your ```OUTGOING_WEBHOOK_TOKEN``` config variable. Give the command a name and a cool icon. That's it!

Thanks to https://deckbrew.com/api/ for their awesome API
