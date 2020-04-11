require 'facebook/messenger'

require_relative '../utils.rb'
require_relative '../wit/get_wit_message'
require_relative 'json_templates/greeting'
require_relative 'json_templates/persistent_menu'
require_relative 'json_templates/get_started'
require_relative 'json_templates/template'
require_relative 'json_templates/quick_replies'
require_relative './news.rb'
require_relative './faq.rb'
require_relative './helpdesk_number'
require_relative './doctors_advice'
require_relative './prevention_methods'
require_relative 'strings'


include Facebook::Messenger

class MessengerBot

	# @param id [Integer] The Facebook User ID.
	# @return [JSON]A JSON object that contains first_name,lastname,profile_pic_url,locale,gender of the user.
	# This method is used to get the user profile information from the Facebook.
	#
	def self.get_profile(id)
		begin 
	 		fb_profile_url = FB_PROFILE + id + FB_PROFILE_FIELDS
	 		profile_details = HTTParty.get(fb_profile_url)
	 		@first_name = profile_details["first_name"]
	 		@last_name = profile_details["last_name"]
	 		@profile_pic = profile_details["profile_pic"]
	 		@locale = profile_details["locale"]
	 		@gender = profile_details["gender"]
	 		puts "Profile details : \nlocale : "+@locale +"\ngender : "+@gender
	 		return profile_details
	 	rescue => e
	 		puts "Error in get_profile" +e.to_s
	 	end
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
				quick_replies: get_quick_replies(@language)
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

  	# @param id [Integer] The Facebook User ID.
 	# @return [String] The language that the user had set in his/her Facebook profile.
 	# This method is used to get the language of the user set in the Facebook.
 	#
 	def self.get_language(id)
 		# TODO Rewrite this with get from user preference with the language setting
 		fb_profile_url = FB_PROFILE + id + FB_PROFILE_FIELDS
 		profile_details = HTTParty.get(fb_profile_url)
 		locale = profile_details["locale"]
 		language = (locale == nil)? "en" : locale[0,2]
 		puts "Language : "+language
 		return language
 	end

 	def self.set_language_value(id)
		@language = get_language(id)
		@language = "en" unless SUPPORTED_LANGUAGE.include?(@language)
 	end

  	# @param id [Integer] The receiver's Facebook user ID.
	# @param message [String] This object contains the message content that the user had sent to the chatbot.
	# @return [nil]
	# This method will handle messages.
	#
	def self.handle_message(id,message)
		begin
			message = message.downcase  # handle only text messages 
		rescue   
			message = "hi"
		end
		begin
			case message
			when NEWS["#{@language}"].downcase
				handle_postback(id,"NEWS")
			else
				handle_wit_response(id,message)
			end
		rescue => e 
			puts "Error occured inside handle_message : " + e.to_s
			say(id,UNABLE_TO_GET_THE_CONTENT["#{@language}"])
		end
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
			puts "Unable to predict the intent by wit"
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
		puts "inside handle_postback"
		begin
			case postback_payload
			when "GET_STARTED"
				greeting_message = GREETING_MESSAGE["#{@language}"]
				say(id,greeting_message)
				send_quick_reply(id)
			when "NEWS"
				# news_contents = get_news(@language)
				post_template(id,get_news(@language))
			when "FAQ"
				# faq_contents = get_faqs(@language)
				post_template(id,get_faqs(@language))
			when "STATS"
			when "HELPDESK_NUMBER"
				post_helpdesk_number(id,@language)
			when "MAIN_MENU"
				send_quick_reply(id)
			when "PREVENTION_METHODS"
				# precaution_contents = get_prevention_methods(@language)
				post_template(id,get_prevention_methods(@language))
			when "DOCTORS_ADVICE"
				# doctors_advice = get_doctors_advice(@language)
				post_template(id,get_doctors_advice(@language))
			when "ABOUT_THE_VIRUS"
			else
				handle_get_summary_postbacks(id,postback_payload)
			end
		rescue => e
			puts "Error occured inside handle_postback :" + e.to_s
			say(id,UNABLE_TO_GET_THE_CONTENT["#{@language}"])
		end
	end

	def self.handle_get_summary_postbacks(id,postback)
		if postback.include? "GET_NEWS_SUMMARY_"
			uniqueId = postback.delete("GET_NEWS_SUMMARY_")
			puts "Get news summary uniqueid: " + uniqueId
			answer = get_news_summary(uniqueId,@language)
		elsif postback.include? "GET_FAQ_ANSWER_SUMMARY_"
			uniqueId = postback.delete("GET_FAQ_ANSWER_SUMMARY_")
			puts "FAQ uniqueid: " + uniqueId 
			answer = get_faqs_answer(uniqueId,@language)
		elsif postback.include? "GET_PREVENTION_SUMMARY_"
			uniqueId = postback.delete("GET_PREVENTION_SUMMARY_")
			puts "PREVENTION_METHODS uniqueid: " + uniqueId 
			answer = get_prevention_methods_summary(uniqueId,@language)
		elsif postback.include? "GET_DOCTORS_ADVICE_SUMMARY_"
			uniqueId = postback.delete("GET_DOCTORS_ADVICE_SUMMARY_")
			puts "GET_DOCTORS_ADVICE_SUMMARY uniqueId : " + uniqueId
			answer = get_doctors_advice_summary(uniqueId,@language)
		else
			send_quick_reply(id)
			return
		end
		if answer == nil
				answer = UNABLE_TO_GET_THE_CONTENT["#{@language}"]
		end
		say(id, answer)	
	end

	# Initial configuration for the bot 
	Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["FB_ACCESS_TOKEN"],
		subscribed_fields: %w[messages messaging_postbacks])
	greeting_response 		 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GREETING.to_json )
	get_started_response	 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GET_STARTED.to_json)
	persistent_menu_response =HTTParty.post(FB_PAGE, headers: HEADER, body: get_persistent_menu.to_json)

	# Triggers whenever the bot gets any messages from the facebook user.
	Bot.on :message do |message|
		puts "Received a message: " + message.text
		id = message.sender["id"]
		typing_on(id)
		set_language_value(id)
		handle_message(id,message.text)
	end

	# Triggers whenever the bot gets any postbacks from the facebook user.
	Bot.on :postback do |postback|
		puts "Received a postback : " + postback.payload
		id = postback.sender["id"]
		set_language_value(id)
		handle_postback(id,postback.payload)
	end

	# @param id [Integer] The receiver's Facebook user ID.
	# @param template [JSON] The MessageCard to be posted to user's Messager chat.
	# @return [nil]
	# This method helps to post the MessageCards that contains image,title,subtile & button.
	#
	def self.post_template(id,template)
		message_options = {
		"messaging_type": "RESPONSE",
        "recipient": { "id": "#{id}"},
        "message": "#{template.to_json}"
        }
		res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options.to_json)
		puts "Posted message template response: " + res
	end

end