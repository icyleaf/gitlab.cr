module Gitlab
  class Client
    # Defines methods related to key.
    #
    # See [http://docs.gitlab.com/ce/api/keys.html](http://docs.gitlab.com/ce/api/keys.html)
    module Key
      # Get SSH key in an authenticated user.
      #
      # - param  [Int32] key_id The ID or ssh key.
      # - return [JSON::Any] Information about logged in user.
      #
      # ```
      # client.key(2)
      # ```
      def key(key_id : Int32) : JSON::Any
        get("keys/#{key_id}").parse
      end

      # Get SSH key by fingerprint.
      #
      # - param  [String] fingerprint The fingerprint or ssh key.
      # - return [JSON::Any] Information about logged the key.
      #
      # ```
      # client.key_by_fingerprint("9f:70:33:b3:50:4d:9a:a3:ef:ea:13:9b:87:0f:7f:7e")
      # ```
      def key_by_fingerprint(fingerprint : String) : JSON::Any
        get("keys", params: {"fingerprint" => fingerprint}).parse
      end
    end
  end
end
