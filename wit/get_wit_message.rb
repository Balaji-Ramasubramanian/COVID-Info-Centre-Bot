require 'wit'

# @author Balaji
class Wit

	# @param phrase [String] The sentence which has to be processed by Wit.ai.
	# @return [String] It denotes the entity values from the sentence processed by Wit.
	# Method to get entities from wit server
	#
	def get_intent(phrase,language)
		wit_access_token = "WIT_ACCESS_TOKEN_" + language
		begin
			client = Wit.new(access_token: ENV["#{wit_access_token}"])
			response = client.message(phrase)
		rescue
			client = Wit.new(access_token: ENV["#{WIT_ACCESS_TOKEN_en}"])
			response = client.message(phrase)
		end

		if response["entities"]["intent"] != nil then
			return response["entities"]["intent"][0]["value"]
		elsif response["entities"]["greetings"] != nil then
			return "HI"
		else 
			return "INTENT_NOT_FOUND"
		end

	end
end
