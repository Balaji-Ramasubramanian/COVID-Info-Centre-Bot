require_relative "../../strings"

# @author Balaji
class MessengerBot

  # Persistent menu template - Default(English)
  PERSISTENT_MENU_STRING_DEFAULT =
    {
        "locale": "default",
        "composer_input_disabled": false,
        "call_to_actions": [
          {
            "title": NEWS["en"],
            "type": "postback",
            "payload": "NEWS"
          },
          {
            "title": FAQ["en"],
            "type": "postback",
            "payload": "FAQs"
          },
          {
            "title": HELPDESK_NUMBER["en"],
            "type": "postback",
            "payload": "HELPDESK_NUMBER"
          },
          {
            "title": ABOUT_THE_VIRUS["en"],
            "type": "postback",
            "payload": "ABOUT_THE_VIRUS"
          }
        ]
    }

end