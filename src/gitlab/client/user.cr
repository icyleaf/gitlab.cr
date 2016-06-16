module Gitlab
  class Client
    # Defines methods related to users.
    # @see http://docs.gitlab.com/ce/api/users.html
    module User
      # Gets a list of users.
      #
      # @example
      #   client.users
      #
      # @param  [Hash] options A customizable set of options.
      # @option options [String] :page The page number.
      # @option options [String] :per_page The number of results per page.
      # @return [Array<Hash>]
      def users(params : Hash? = nil)
        get("users", params).body
      end

      # Gets information about a user.
      # Will return information about an authorized user if no ID passed.
      #
      # @example
      #   client.user(2)
      #
      # @param  [Integer] id The ID of a user.
      # @return [Hash]
      def user(id : Int32 = nil)
        get("/users/#{id.to_s}").body
      end

      # Creates a new user.
      # Requires authentication from an admin account.
      #
      # @example
      #   Gitlab.create_user('joe@foo.org', 'secret', 'joe', { name: 'Joe Smith' })
      #   or
      #   Gitlab.create_user('joe@foo.org', 'secret')
      #
      # @param  [String] email The email of a user.
      # @param  [String] password The password of a user.
      # @param  [String] username The username of a user.
      # @param  [Hash] params A customizable set of options.
      # @option params [String] :name The name of a user. Defaults to email.
      # @option params [String] :skype The skype of a user.
      # @option params [String] :linkedin The linkedin of a user.
      # @option params [String] :twitter The twitter of a user.
      # @option params [Integer] :projects_limit The limit of projects for a user.
      # @return [Hash] Information about created user.
      def create_user(email : String, password : String, username : String, params : Hash = {} of String => String)
        params = {
          "email"    => email,
          "password" => password,
          "username" => username,
        }.merge(params)

        post("/users", params: params)
      end
    end
  end
end
