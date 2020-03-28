require 'facebook/messenger'

require_relative '../utils.rb'
require_relative './featured_article'
require_relative './pages'
require_relative '../wit/get_wit_message'
require_relative 'json_templates/greeting'
require_relative 'json_templates/persistent_menu'
require_relative 'json_templates/get_started'
require_relative 'json_templates/template'
require_relative 'json_templates/quick_replies'
require_relative '../subscription/subscription'
require_relative 'strings'


include Facebook::Messenger

class MessengerBot

	# @param id [Integer] The Facebook User ID.
	# @return [JSON]A JSON object that contains first_name,lastname,profile_pic_url,locale,gender of the user.
	# This method is used to get the user profile information from the Facebook.
	#
	def self.get_profile(id)
 		fb_profile_url = FB_PROFILE + id + FB_PROFILE_FIELDS
 		profile_details = HTTParty.get(fb_profile_url)
 		@first_name = profile_details["first_name"]
 		@last_name = profile_details["last_name"]
 		@profile_pic = profile_details["profile_pic"]
 		@locale = profile_details["locale"]
 		@gender = profile_details["gender"]
 		puts "Profile details : \nlocale : "+@locale +"\ngender : "+@gender
 		return profile_details
 	end

 	# @param recipient_id [Integer] The receiver's Facebook user ID.
 	# @param text [String] The text content that has to be sent to the user.
 	# @return [nil].
 	# This method is used to push a text message to a particular user in Facebook Messenger.
 	#
	def self.say(recipient_id, text)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: recipient_id },
			message: { text: text }
		}
		res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options.to_json)
	end

	# @param id [Integer] The receiver's Facebook user ID.
	# @return [nil]
	# This method is used to send a quick reply to the user.
	#
	def self.send_quick_reply(id)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id},
			message: {
				text: QUICK_REPLY_HEADER["#{@language}"],
				quick_replies: QUICK_REPLIES["#{@language}"] 
			}
		}
	 	response = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options.to_json)
	 end

	# @param id [Integer] The receiver's Facebook user ID.
	# @return [nil]
	# This method is used to show the typing indication to the user.
	#
	def self.typing_on(id)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id },
			sender_action: "typing_on",
		}
		response = HTTParty.post(FB_MESSAGE,headers: HEADER, body: message_options.to_json)		
  	end

	# Initial configuration for the bot 
	Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["FB_ACCESS_TOKEN"],
		subscribed_fields: %w[messages feed mention name messaging_postbacks])
	greeting_response 		 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GREETING.to_json )
	get_started_response	 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GET_STARTED.to_json)
	persistent_menu_response =HTTParty.post(FB_PAGE, headers: HEADER, body: PERSISTENT_MENU.to_json)

	# Triggers whenever the bot gets any messages.
	Bot.on :message do |message|
		puts "Received a message: " + message.text
		id = message.sender["id"]
		typing_on(id)
		set_language_value(id)
		handle_message(id,message.text)
	end

	# Triggers whenever the bot gets any postbacks.
	Bot.on :postback do |postback|
		puts "Received a postback : " + postback.payload
		id = postback.sender["id"]
		set_language_value(id)
		handle_postback(id,postback.payload)
	end

	# @param id [Integer] The receiver's Facebook user ID.
	# @param message [String] This object contains the message content sent from the 'handle_message' method.
	# @return [nil]
	# Uses Wit.ai to find the intent of the message
	#
	def self.handle_wit_response(id,message)
		wit_response = Wit.new.get_intent(message,@language)
		puts "Wit response : " + wit_response.to_s
		if wit_response.class == String then
			handle_postback(id,wit_response)
		else
			say(id,UNABLE_TO_GET_THE_CONTENT["#{@language}"])
		end
	end

	# @param id [Integer] The receiver's Facebook user ID.
	# @param postback_payload [String] It contains the payload of Button/MessageCards/Menu.
	# @return [nil]
	# This method handles postbacks.
	#
	def self.handle_postback(id,postback_payload)
		typing_on(id)
		begin
			case postback_payload
			when "GET_STARTED"
				greeting_message = GREETING_MESSAGE["#{@language}"]
				SubscriptionClass.new.save_user_profile(id)
				say(id,greeting_message)
				send_quick_reply(id)
			when "NEWS"
				get_news(id)
			else
				say(id,UNABLE_TO_GET_THE_CONTENT["#{@language}"])
			end
		rescue
			say(id,UNABLE_TO_GET_THE_CONTENT["#{@language}"])
		end
	end

end