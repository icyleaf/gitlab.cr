module Gitlab
  class Client
    # Defines methods related to users.
    #
    # See http://docs.gitlab.com/ce/api/users.html
    module User
      # Gets a list of users.
      #
      # - param  [Hash] options A customizable set of options.
      # - option options [String] :page The page number.
      # - option options [String] :per_page The number of results per page.
      # - return [Array<Hash>]
      #
      # ```
      # client.users
      # client.users({ "per_page" => "10", "page" => "2" })
      # ```
      def users(params : Hash? = nil) : JSON::Any
        get("users", params).body
      end

      # Gets information about a user.
      # Will return information about an authorized user if no ID passed.
      #
      # - param  [Integer] id The ID of a user.
      # - return [Hash]
      #
      # ```
      # client.user(2) # Get user information by ID = 2
      # ```
      def user(id : Int32 = nil) : JSON::Any
        get("/users/#{id.to_s}").body
      end

      # Creates a new user.
      # Requires authentication from an admin account.
      #
      # - param  [String] email The email of a user.
      # - param  [String] password The password of a user.
      # - param  [String] username The username of a user.
      # - param  [Hash] params A customizable set of options.
      # - option params [String] :name The name of a user. Defaults to email.
      # - option params [String] :skype The skype of a user.
      # - option params [String] :linkedin The linkedin of a user.
      # - option params [String] :twitter The twitter of a user.
      # - option params [Integer] :projects_limit The limit of projects for a user.
      # - return [Hash] Information about created user.
      #
      # ```
      # Gitlab.create_user("hello@world.org", "secret", "hellworld", { "name" => "Joe Smith" })
      # Gitlab.create_user("hello@world.org", "secret", "hellworld")
      # ```
      def create_user(email : String, password : String, username : String, params : Hash = {} of String => String) : Hash
        params = {
          "email"    => email,
          "password" => password,
          "username" => username,
          "name"     => username,
        }.merge(params)

        post("/users", params: params).body
      end
    end
  end
end
