# @author Balaji
class MessengerBot

	# Supported Languages
	SUPPORTED_LANGUAGE = ["en", "ta"]
	# Greeting Text:
	GREETING_MESSAGE = {
		"en" => "Hey! This bot helps you to get the latest news about COVID-19, Get helpdesk numbers, or FAQs about the virus.",
		"ta" => "வணக்கம்!"
	}

	# Quick reply header text:
	QUICK_REPLY_HEADER = {
		"en" => "How can I help you?",
		"ta" => "நான் உங்களுக்கு ஏவ்வாறு உதவ வேண்டும்?"
	}

	# Quick reply option texts:
	QUICK_REPLY_OPTIONS = {
		"News" => {
			"en" => "News",
			"ta" => "செய்திகள்" 
		},
		"FAQ" => {
			"en" => "FAQs",
			"ta" => "கேள்விகள்"
		}
	}

	# Error message - Can't understand users message texts:
	CANT_UNDERSTAND_MESSAGE = {
		"en" => "Sorry, I couldn't understand that.",
		"ta" => "மன்னிக்கவும், எனக்கு புரியவில்லை."
	}

	# Message Card button texts - Read More:
	READ_MORE_BUTTON = {
		"en" => "Read More",
		"ta" => "மேலும் வாசிக்க"
	}

	# Message Card button texts - View on Browser:
	VIEW_ON_BROWSER_BUTTON = {
		"en" => "View on Browser",
		"ta" => "உலாவியில் பார்க்கவும்"
	}

	# Message Card button texts - Get Summary:
	GET_SUMMARY_BUTTON = {
		"en" => "Get Summary",
		"ta" => "நிகழ்ச்சி சுருக்கம்"
	}

	# Message Card button tests - Get Answer:
	GET_FAQ_ANSWER_BUTTON = {
		"en" => "Get Answer",
		"ta" => "பதிலைக் காட்டு"
	}
	# Persistant menu button texts - Image Of The Day:
	IMAGE_OF_THE_DAY_MESSAGE = {
		"en" => "Image Of The Day",
		"ta" => "இன்றைய சிறப்பு படம்"
	}

	# Persistant menu button texts - News:
	NEWS = {
		"en" => "News",
		"ta" => "செய்திகள்"
	}

	# Persistant menu button texts - FAQs
	FAQ = {
		"en" => "FAQs",
		"ta" => "கேள்விகள்"
	}

	# Persistant menu button texts - HelpDesk number
	HELPDESK_NUMBER = {
		"en" => "HelpDesk Number",
		"ta" => "உதவி மைய எண்"
	}

	ABOUT_THE_VIRUS = {
		"en" => "About the virus",
		"ta" => "வைரஸ் பற்றி"
	}
 	# Button texts - Help:
 	HELP_BUTTON = {
 		"en" => "Help",
 		"ta" => "உதவி"
 	}

 	# Button texts - More:
 	MORE_BUTTON = {
 		"en" => "More",
 		"ta" => "மேலும்"
 	}


 	# Error text - Uable to get the content
 	UNABLE_TO_GET_THE_CONTENT = {
 		"en" => "Sorry, I'm unable to get the content right now! Please try again later",
 		"ta" => "மன்னிக்கவும், என்னால் இப்போது உள்ளடக்கத்தைப் பெற முடியவில்லை! பின்னர் மீண்டும் முயற்சிக்கவும்"
 	}

end