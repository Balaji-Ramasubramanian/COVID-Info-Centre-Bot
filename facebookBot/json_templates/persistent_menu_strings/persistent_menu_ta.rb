require_relative "../../strings"

# @author Balaji
class MessengerBot

  # Persistent menu template - Default(English)
  PERSISTENT_MENU_STRING_TA =
    {
        "locale": "ta_IN",
        "composer_input_disabled": false,
        "call_to_actions": [
          {
            "title": NEWS["ta"],
            "type": "postback",
            "payload": "NEWS"
          },
          {
            "title": FAQ["ta"],
            "type": "postback",
            "payload": "FAQ"
          },
          {
            "title": HELPDESK_NUMBER["ta"],
            "type": "postback",
            "payload": "HELPDESK_NUMBER"
          },
          {
            "title": ABOUT_THE_VIRUS["ta"],
            "type": "postback",
            "payload": "ABOUT_THE_VIRUS"
          }
        ]
    }

end