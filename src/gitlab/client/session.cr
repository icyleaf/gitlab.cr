module Gitlab
  class Client
    # Defines methods related to session.
    #
    # See [http://docs.gitlab.com/ce/api/session.html](http://docs.gitlab.com/ce/api/session.html)
    module Session
      # Creates a new user session.
      #
      # - param  [String] login The email or username of a user.
      # - param  [String] password The password of a user.
      # - return [Hash] Information about logged in user.
      #
      # ```
      # client.session("jack@example.com", "secret12345")
      # client.session("jack", "secret12345")
      # ```
      def session(login : String, password : String) : JSON::Any
        JSON.parse post("/session", form: {"email" => login, "password" => password}).body
      end
    end
  end
end
