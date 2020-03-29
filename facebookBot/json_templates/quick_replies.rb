require_relative '../strings'
require_relative '../bot'
Dir[File.join(__dir__, './quick_replies_strings', '*')].each { |file| require file }

# @author Balaji
class MessengerBot

	def self.get_quick_replies(language)
		quick_reply = [
			  	{
			    	"content_type": 'text',
			    	"title": QUICK_REPLY_OPTIONS["News"]["#{language}"],
			    	"payload": 'NEWS'
			  	},
			  	{
		    	"content_type": 'text',
		    	"title": QUICK_REPLY_OPTIONS["FAQ"]["#{language}"],
		    	"payload": 'NEWS'
		  	}
		]
		return quick_reply
	end

end
