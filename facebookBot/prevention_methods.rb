require 'facebook/messenger'
require 'json'

require_relative '../utils.rb'
require_relative '../api_endpoints.rb'
require_relative 'strings'
require_relative 'json_templates/template'


class MessengerBot

	def self.get_prevention_methods_contents
		begin
			puts "inside get_prevention_methods_contents method"
			prevention_methods_response = JSON.parse(HTTParty.get(PREVENTION_METHODS_URL).to_s)
 			return prevention_methods_response["precautionMeasures"]
		rescue Exception => e
			puts "Error in get_prevention_methods_contents: " + e
		end
	end

	# Get the prevention methods from the specified url and parse it like a message card template
	def self.get_prevention_methods(language)
		begin
			prevention_methods_contents = get_prevention_methods_contents
			prevention_methods_template = GENERIC_TEMPLATE_BODY
			elements = []
			(0..9).each { |i|
				break if i > prevention_methods_contents.length-1
				puts prevention_methods_contents[i]
				title = prevention_methods_contents[i]["title"+language.capitalize]
				text =  prevention_methods_contents[i]["summary"+language.capitalize]
				unique_id = prevention_methods_contents[i]["uniqueId"]
				new_element = {
			            "title": title,
			            "subtitle": text,
			            "buttons":[
			            	{
			              		"type": "postback",
			              		"title": GET_SUMMARY_BUTTON["#{@language}"],
			              		"payload": "GET_PREVENTION_SUMMARY_" + unique_id.to_s  # Add uniqueid value with the payload
			            	}
			            ]
			    }
			    elements << new_element		
			}
			prevention_methods_template[:attachment][:payload][:elements] = elements
			return prevention_methods_template
		rescue => e
			puts "Error inside get_prevention_methods : " + e.to_s
		end
	end

	# Get the prevention methods summary
	def self.get_prevention_methods_summary(uniqueId,language)
		begin
			prevention_methods_contents = get_prevention_methods_contents
			elements = []
			summary = nil
			(0..9).each { |i|
				puts prevention_methods_contents[i]["uniqueId"]
				break if i > prevention_methods_contents.length-1
				if prevention_methods_contents[i]["uniqueId"].to_s == uniqueId
					puts "prevention methods contents found by uniqueId"
					return prevention_methods_contents[i]["summary"+language.capitalize]
				end
			}
			return summary
		rescue => e
			puts "Error inside get_prevention_methods_summary : " + e.to_s
		end
	end

end