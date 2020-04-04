require 'facebook/messenger'
require 'json'

require_relative '../utils.rb'
require_relative '../api_endpoints.rb'
require_relative 'strings'
require_relative 'json_templates/template'


class MessengerBot

	# Get the news from the specified url and parse it like a message card template
	def self.get_news(language)
		begin
			news_response = JSON.parse(HTTParty.get(NEWS_URL).to_s)
	 		news_contents = news_response["news"]
			news_template = GENERIC_TEMPLATE_BODY
			elements = []
			(0..9).each { |i|
				break if i > news_contents.length-1
				puts news_contents[i]
				title = news_contents[i]["title"+language.capitalize]
				text =  news_contents[i]["summary"+language.capitalize]
				news_unique_id = news_contents[i]["uniqueId"]
				new_element = {
			            "title": title,
			            "subtitle": text,
			            "buttons":[
			            	{
			              		"type": "postback",
			              		"title": GET_SUMMARY_BUTTON["#{@language}"],
			              		"payload": "GET_NEWS_SUMMARY_"+news_unique_id.to_s  # Add uniqueid value with the payload
			            	}
			            ]
			    }
			    elements << new_element		
			}
			news_template[:attachment][:payload][:elements] = elements
			return news_template
		rescue => e
			puts "Error inside get_news : " + e.to_s
		end
	end

	# Get the news summary
	def self.get_news_summary(uniqueId,language)
		begin
			news_response = JSON[HTTParty.get(NEWS_URL).to_s]
	 		news_contents = news_response["news"]
	 		puts "News Contents: #{news_contents}"
			elements = []
			summary = nil
			(0..9).each { |i|
				puts news_contents[i]["uniqueId"]
				break if i > news_contents.length-1
				if news_contents[i]["uniqueId"].to_s == uniqueId
					puts "news content found by uniqueId"
					return news_contents[i]["summary"+language.capitalize]
				end
			}
			return summary
		rescue => e
			puts "Error inside get_news_summary : " + e.to_s
		end
	end

end