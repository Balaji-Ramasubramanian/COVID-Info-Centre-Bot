require 'facebook/messenger'
require 'json'

require_relative '../utils.rb'
require_relative '../api_endpoints.rb'
require_relative 'strings'
require_relative 'json_templates/template'


class MessengerBot

	def self.get_doctors_advice_content 
		begin
			puts "insdide get_doctors_advice"
			doctors_advice_response = JSON.parse(HTTParty.get(DOCTORS_ADVICE_URL).to_s)
	 		return doctors_advice_response["adviceByDoctor"]
		rescue Exception => e
			puts "Error in get_doctors_advice_content: " + e.to_s
		end
	end

	# Get the doctors advice from the specified url and parse it like a message card template
	def self.get_doctors_advice(language)
		begin
			doctors_advice_contents = get_doctors_advice_content
			doctors_advice_template = GENERIC_TEMPLATE_BODY
			elements = []
			(0..9).each { |i|
				break if i > doctors_advice_contents.length-1
				puts doctors_advice_contents[i]
				title = doctors_advice_contents[i]["title"+language.capitalize]
				text =  doctors_advice_contents[i]["summary"+language.capitalize]
				unique_id = doctors_advice_contents[i]["uniqueId"]
				new_element = {
			            "title": title,
			            "subtitle": text,
			            "buttons":[
			            	{
			              		"type": "postback",
			              		"title": GET_SUMMARY_BUTTON["#{@language}"],
			              		"payload": "GET_DOCTORS_ADVICE_SUMMARY_"+unique_id.to_s  # Add uniqueid value with the payload
			            	}
			            ]
			    }
			    elements << new_element		
			}
			doctors_advice_template[:attachment][:payload][:elements] = elements
			return doctors_advice_template
		rescue => e
			puts "Error inside get_doctors_advice : " + e.to_s
		end
	end

	# Get the doctors advice summary
	def self.get_doctors_advice_summary(uniqueId,language)
		begin
			doctors_advice_contents = get_doctors_advice_content
	 		puts "doctors advice contents: #{doctors_advice_contents}"
			elements = []
			summary = nil
			(0..9).each { |i|
				puts doctors_advice_contents[i]["uniqueId"]
				break if i > doctors_advice_contents.length-1
				if doctors_advice_contents[i]["uniqueId"].to_s == uniqueId
					puts "doctors advice contents found by uniqueId"
					return doctors_advice_contents[i]["summary"+language.capitalize]
				end
			}
			return summary
		rescue => e
			puts "Error inside get_doctors_advice_summary : " + e.to_s
		end
	end

end