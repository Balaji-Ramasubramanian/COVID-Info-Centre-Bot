require_relative "../../strings"

# @author Balaji
class MessengerBot

  # Persistent menu template - Default(English)
  PERSISTENT_MENU_STRING_TA =
    {
        "locale": "default",
        "composer_input_disabled": false,
        "call_to_actions": [
          {
            "title": NEWS["ta"],
            "type": "postback",
            "payload": "NEWS"
          }
        ]
      }

end