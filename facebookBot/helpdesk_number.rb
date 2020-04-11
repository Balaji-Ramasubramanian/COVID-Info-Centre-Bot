require 'facebook/messenger'
require 'json'

require_relative '../utils.rb'
require_relative '../api_endpoints.rb'
require_relative 'strings'
require_relative 'json_templates/template'


class MessengerBot

	def self.post_helpdesk_number(id,language)
		begin
			puts "Inside get_helpdesk_number"
			helpdesk_information = JSON[HTTParty.get(HELPDESK_NUMBER_URL).to_s]
			puts helpdesk_information.to_s
			helpdesk_content = helpdesk_information["helpDeskInstructions"]
			helpdesk_content.each { |content|
				say(id,content["helpdeskNumber"+language.capitalize])
			}
			return helpdesk_information["helpdesk_number"+language.capitalize] 
		rescue  => e
			puts "Error in get_helpdesk_number : " + e.to_s
		end
	end
	
end