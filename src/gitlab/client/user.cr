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
      def users(params : Hash? = nil)
        get("users", params).body
      end

      # Gets information about a user.
      #
      # - param  [Int32] id The ID of a user.
      # - return [Hash]
      #
      # ```
      # client.user(2) # Get user information by ID = 2
      # ```
      def user(id : Int32 = nil)
        get("/users/#{id.to_s}").body
      end

      # Gets information about current user.
      #
      # - return [Hash]
      #
      # ```
      # client.user # Get current user information
      # ```
      def user
        get("/user").body
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
      # Gitlab.create_user("icy.leaf@kaifeng.cn", "secret", "icyleaf", { "name" => "三火" })
      # Gitlab.create_user("icy.leaf@kaifeng.cn", "secret", "icyleaf")
      # ```
      def create_user(email : String, password : String, username : String, params : Hash = {} of String => String)
        params = {
          "email"    => email,
          "password" => password,
          "username" => username,
          "name"     => username,
        }.merge(params)

        post("/users", params: params).body
      end

      # Updates a user.
      #
      # - param  [Int32] id The ID of a user.
      # - param  [Hash] options A customizable set of options.
      # - option options [String] :email The email of a user.
      # - option options [String] :password The password of a user.
      # - option options [String] :name The name of a user. Defaults to email.
      # - option options [String] :skype The skype of a user.
      # - option options [String] :linkedin The linkedin of a user.
      # - option options [String] :twitter The twitter of a user.
      # - option options [String] :projects_limit The limit of projects for a user.
      # - return [Hash] Information about edit user.
      #
      # ```
      # client.edit_user(4, { "email" => "icy.leaf@kaifeng.cn", "projects_limit" => "100" })
      # ```
      def edit_user(user_id : Int32, params : Hash = {} of String => String)
        put("/users/#{user_id.to_s}", params)
      end

      # Deletes a user.
      #
      # - param [Int32] id The ID of a user.
      # - return [Hash] Information about deleted user.
      #
      # ```
      # client.delete_user(1)
      # ```
      def delete_user(user_id : Int32)
        delete("/users/#{user_id.to_s}")
      end

      # Blocks the specified user.
      #
      # **Available only for admin**.
      #
      # - param [Integer] user_id The Id of user
      # - return [Hash] success or not
      #
      # ```
      # client.block_user(4)
      # ```
      def block_user(user_id : Int32)
        put("/users/#{user_id.to_s}/block")
      end

      # Unblocks the specified user.
      #
      # **Available only for admin**.
      #
      # - param [Integer] user_id The Id of user
      # - return [Hash] success or not
      #
      # ```
      # client.unblock_user(4)
      # ```
      def unblock_user(user_id : Int32)
        put("/users/#{user_id.to_s}/unblock")
      end
    end
  end
end
