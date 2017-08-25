module Gitlab
  class Client
    # Defines methods related to key.
    #
    # See [http://docs.gitlab.com/ce/api/keys.html](http://docs.gitlab.com/ce/api/keys.html)
    module Key
      # Get SSH key in an authenticated user.
      #
      # - param  [String] key_id The ID or ssh key.
      # - param  [String] password The password of a user.
      # - return [Hash] Information about logged in user.
      #
      # ```
      # client.key(2)
      # ```
      def key(key_id : Int32)
        get("/keys/#{key_id}").body.parse_json
      end
    end
  end
end
