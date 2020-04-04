require 'facebook/messenger'
require 'json'

require_relative '../utils.rb'
require_relative '../api_endpoints.rb'
require_relative 'strings'
require_relative 'json_templates/template'


class MessengerBot

	def self.get_helpdesk_number(language)
		begin
			helpdesk_information = JSON[HTTParty.get(HELPDESK_NUMBER_URL).to_s]
			return helpdesk_information["helpdesk_number"+language.capitalize] 
		rescue  => e
			puts "Error in get_helpdesk_number : " + e.to_s
		end
	end
	
end