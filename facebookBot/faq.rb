require 'facebook/messenger'
require 'json'

require_relative '../utils.rb'
require_relative '../api_endpoints.rb'
require_relative 'strings'
require_relative 'json_templates/template'

class MessengerBot

	def self.get_faq_contents
		begin
			faq_response = JSON[HTTParty.get(FAQ_URL).to_s]
			return faq_response["faQs"]
		rescue Exception => e
			
		end
	end

	def self.get_faqs(language)
		begin
			faq_contents = get_faq_contents
			puts "FAQ Contents: #{faq_contents}"
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
		rescue => e
			puts "Error in get_faqs : "+ e.to_s
		end
	end

	def self.get_faqs_answer(uniqueId,language)
		begin
			faq_contents = get_faq_contents
			puts "FAQ Contents: #{faq_contents}"
			elements = []
			summary = nil
			(0..9).each { |i|
				break if i > faq_contents.length-1
				if faq_contents[i]["uniqueId"].to_s == uniqueId
					return faq_contents[i]["answer"+language.capitalize]
				end
			}
			return summary
		rescue => e
			puts "Error in get_faqs_answer " + e.to_s
		end
	end
end