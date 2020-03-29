require_relative "../strings"

# @author Balaji
class MessengerBot

	def self.get_persistent_menu(hey) 
		persistent_menu_elements = []
		SUPPORTED_LANGUAGE.each { |language,locale|
			puts language
			persistent_menu_elements << get_persistent_menu_element(language,locale)
		}
		persistent_menu = {
	    "persistent_menu": persistent_menu_elements
		}
		puts persistent_menu
		return persistent_menu
	end

	def self.get_persistent_menu_element(language,locale)
		persistent_menu_element = {
	    "locale": "#{locale}",
	    "composer_input_disabled": false,
	    "call_to_actions": [
	      {
	        "title": NEWS["#{language}"],
	        "type": "postback",
	        "payload": "NEWS"
	      },
	      {
	        "title": FAQ["#{language}"],
	        "type": "postback",
	        "payload": "FAQ"
	      },
	      {
	        "title": MORE["#{language}"] ,
	        "type": "nested",
	        "call_to_actions": [
	            {
	              "title": HELPDESK_NUMBER["#{language}"],
	              "type": "postback",
	              "payload": "HELPDESK_NUMBER"
	            },
	            {
	              "title": ABOUT_THE_VIRUS["#{language}"],
	              "type": "postback",
	              "payload": "ABOUT_THE_VIRUS"
	            },
	            {
	              "title": PREVENTION_METHODS["#{language}"],
	              "type": "postback",
	              "payload": "PREVENTION_METHODS"
	            }
	        ]
	      }
	    ]
	}
	return persistent_menu_element
	end

end