# COVID Info Centre Facebook Chatbot

This project is a Facebook Messenger bot which aims to deliver information about the pandemic COVID-19. By using this code as a template any government and healthcare services can provide their service to the public.

## Overview
This Bot provides the following features,
- Latest News
- Provide Helpdesk Number
- Statistics About The Spread
- FAQs
- Precaution Measures
- Advice By Doctors

## How a user can use the bot?
- Go to the chat page in Messenger.
- Click on the *GET STARTED* button to start the conversation.
- You can use the menu present in the chat to send messages quickly.

Sample phrases that the user can use,
- Tell me about the latest news.
- What is the helpline number?
- What are the precaution measures I can follow?
- show me the FAQs.
- show me the advice of the doctors.

## Multi-language support
This bot can support multiple languages. Currently, It is trained in English and Tamil. We can train the bot in other languages as well in the future.

The bot will fetch the user's language preference from their phone and Facebook account's language settings option. If the user has un-supported language, then English will be used.


To add the language strings used within the bot, Goto     `<project_dir>/facebookBot/strings.rb` file and add the required strings with the language code as the key element.

[Wit.ai](https://wit.ai) is used as an NLP agent to handle the user's messages. To train our bot in more languages, we need to train the Wit.ai models and add the access tokens in .env file.

# For developers

## Requirements to deploy this chatbot
- Ruby
- Online hosting server
- Wit Project (For Natural Language Processing)

## Getting started
First, you'll need to fork and clone this repo

Open Terminal. Change the current working directory to the location where you want the cloned directory to be created.

```
git clone https://github.com/Balaji-Ramasubramanian/COVID-Info-Centre-Bot
```
Let's get all our dependencies setup:
```
 bundle install 
```

## Configuration
You need to change the **.env** file with your appropriate access tokens, usernames, and passwords. You need to add the following details,
- The Facebook page access token
- Verify token for your Facebook app
- App secret token
- Wit access token

## Setting up the API endpoints for data input
For data input, you can use an API endpoint. If you're using sheets for data input. You can use sheets to API converter like [Sheety](https://sheety.co).

You can refer [this google sheet](https://docs.google.com/spreadsheets/d/1jMe52ja-41TYFqgeTGw1A8WYcqeiJICt6t84HuJp-fI/edit) for input data reference. **Make sure your API endpoints having the same response format as mentioned in [this doc](https://docs.google.com/document/d/1mJFl1jROujpqoO82UPYWyzPlF5bTtlVVVFyPwWQXUVQ/edit?usp=sharing)**.

The API endpoints should be set in `apiendpoints.rb` file.
The following endpoints should be present

    NEWS_URL=#News endpoint
    FAQ_URL=#FAQ endpoint
    HELPDESK_NUMBER_URL=#Helpdesk instructions endpoint
    ABOUT_THE_VIRUS_URL=# About the virus
    DOCTORS_ADVICE_URL=#Doctors advice
    PREVENTION_METHODS_URL=#Advice by doctors

## Deploying your app:

#### Test your project locally
Download [ngrok](https://ngrok.com) in your local system.

Open the terminal and navigate to the project folder

run `rackup -p <port_number>`.

Open another window in the terminal 

run `<path_of_ngrok_file> http <port_number>`

copy the URL with 'https://' prefix. This is your webhook URL that serves your program.


#### Deploying with Heroku:
You need to have Heroku CLI installed to deploy the bot in Heroku. To find more details about Heroku CLI, [click here](https://devcenter.heroku.com/articles/heroku-cli).

You can follow [this link](https://devcenter.heroku.com/articles/git) to set up the Heroku environment for the project.


## Create an app in Facebook
- Goto [developers.facebook.com](https://developers.facebook.com.)
- Login using your Facebook account username and password.
- Select 'Add New App' under the 'My Apps' section.
- Give a suitable name for your bot and click submit.
- Click 'set up' in Messenger product. Within the Messenger product, Select the page you want to add this chatbot and set up a webhook.

#### Add webhook URL to your Facebook App
In [developers.facebook.com](https://developers.facebook.com.), Navigate to your app's dashboard and click 'webhook' under the products section.
Click the 'Edit Subscription' button and Paste the Webhook URL over there. 

**Note** Don't forget to append '/webhook' after the URL (since config.ru file mapped to the path '/webhook').
```
https://<YOUR_URL>>/webhook
```
Or you can modify your config.ru file in your project to map whatever URL path you want.

## How to add test users?
### Test the app during the development phase
During the development phase, only the admins of the bot and the test users who are added by the admins can use the bot.
Admins of the chatbot can add more Facebook users and also add test users through their app's dashboard.

#### Add new roles to the bot
To add new roles, Navigate to the app's dashboard on [Facebook developer's page](https://developers.facebook.com/apps/).
Click on Roles -> Roles.
On this page, we can add Facebook users to anyone of the roles of admin/developer/tester/analytic user.

#### Add test users
Test Users are temporary Facebook accounts that you can create to test various features of your app.
To add test users for your app, Navigate to Roles -> Test Users and click on add/edit test user accounts.

## Publishing the app
To publish the chatbot, we need to submit our app for the Facebook review.
To do that, click on App Review -> start a submission.

After publishing the app, any Facebook users can access it by directly sending messages to the corresponding Facebook page that hosts the chatbot.

## Contribute
#### Simple 3 step to contribute to this repo:
1. Fork the project.
2. Make the required changes and commit.
3. Generate a pull request. Mention all the required descriptions regarding the changes you have made.

## Author 
#### Balaji Ramasubramanian
If you need any help in customizing and deploying this project, email me @ balaji030698@gmail.com
