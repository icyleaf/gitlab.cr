module Gitlab
  class Client
    # Defines methods related to session.
    #
    # See [http://docs.gitlab.com/ce/api/session.html](http://docs.gitlab.com/ce/api/session.html)
    module Session
      # Creates a new user session.
      #
      # **Note** This method doesn't require private_token to be set.
      #
      # - param  [String] email The email of a user.
      # - param  [String] password The password of a user.
      # - return [Hash] Information about logged in user.
      #
      # ```
      # client.session('jack@example.com', 'secret12345')
      # ```
      def session(email, password)
        post("/session", { "email" => email, "password" => password })
      end
    end
  end
end