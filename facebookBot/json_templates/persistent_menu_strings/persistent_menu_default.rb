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
            "payload": "RANDOM_ARTICLE"
          }
        ]
      }

end