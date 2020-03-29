require 'facebook/messenger'
require 'json'

require_relative '../utils.rb'
require_relative '../api_endpoints.rb'
require_relative 'strings'
require_relative 'json_templates/template'

class MessengerBot

	# Get faqs from api
	def self.get_faq_contents 
		faq_response = HTTParty.get(FAQ_URL)
		faq_response = JSON[faq_response.to_s]
		return faq_response["faqs"]
	end

	def self.get_faqs(language)
		faq_contents = get_faq_contents
		puts faq_contents
		faq_template = GENERIC_TEMPLATE_BODY
		elements = []
		(0..9).each { |i|
			break if i > faq_contents.length-1
			puts faq_contents[i]
			text =  faq_contents[i]["question"+language.capitalize]
			faq_unique_id = faq_contents[i]["uniqueId"]
			new_element = {
		            "title": text,
		            "buttons":[
		            	{
		              		"type": "postback",
		              		"title": GET_FAQ_ANSWER_BUTTON["#{@language}"],
		              		"payload": "GET_FAQ_ANSWER_SUMMARY_"+faq_unique_id.to_s # Adds uniqid with the payload
		            	}
		            ]
		    }
		    elements << new_element		
		}
		faq_template[:attachment][:payload][:elements] = elements
		return faq_template
	end

	def self.get_faqs_answer(uniqueId,language)
		faq_contents = get_faq_contents
		elements = []
		summary = nil
		(0..9).each { |i|
			break if i > faq_contents.length-1
			if faq_contents[i]["uniqueId"].to_s == uniqueId
				return faq_contents[i]["answer"+language.capitalize]
			end
		}
		return summary
	end
end