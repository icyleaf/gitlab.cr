module Gitlab
  class Client
    # Defines methods related to users.
    #
    # See [http://docs.gitlab.com/ce/api/users.html](http://docs.gitlab.com/ce/api/users.html)
    module User
      # Gets a list of users.
      #
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page.
      # - return [Array<Hash>]
      #
      # ```
      # client.users
      # client.users({"per_page" => "10", "page" => "2"})
      # ```
      def users(params : Hash? = nil) : JSON::Any
        JSON.parse get("/users", params: params).body
      end

      # Gets information about current user.
      #
      # - return [Hash]
      #
      # ```
      # client.user
      # ```
      def user : JSON::Any
        JSON.parse get("/user").body
      end

      # Gets information about a user.
      #
      # - param  [Int32] user_id The ID of a user.
      # - return [Hash]
      #
      # ```
      # client.user(2)
      # ```
      def user(user_id : Int32) : JSON::Any
        JSON.parse get("/users/#{user_id.to_s}").body
      end

      # Creates a new user.
      # Requires authentication from an admin account.
      #
      # - param  [String] email The email of a user.
      # - param  [String] password The password of a user.
      # - param  [String] username The username of a user.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :name The name of a user. Defaults to email.
      # - option params [String] :skype The skype of a user.
      # - option params [String] :linkedin The linkedin of a user.
      # - option params [String] :twitter The twitter of a user.
      # - option params [Int32] :projects_limit The limit of projects for a user.
      # - return [Hash] Information about created user.
      #
      # ```
      # Gitlab.create_user("icy.leaf@kaifeng.cn", "secret", "icyleaf", {"name" => "三火"})
      # Gitlab.create_user("icy.leaf@kaifeng.cn", "secret", "icyleaf")
      # ```
      def create_user(email : String, password : String, username : String, params : Hash = {} of String => String) : JSON::Any
        JSON.parse post("/users", form: {
          "email"    => email,
          "password" => password,
          "username" => username,
          "name"     => username,
        }.merge(params)).body
      end

      # Updates a user.
      #
      # - param  [Int32] id The ID of a user.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :email The email of a user.
      # - option params [String] :password The password of a user.
      # - option params [String] :name The name of a user. Defaults to email.
      # - option params [String] :skype The skype of a user.
      # - option params [String] :linkedin The linkedin of a user.
      # - option params [String] :twitter The twitter of a user.
      # - option params [String] :projects_limit The limit of projects for a user.
      # - return [Hash] Information about edit user.
      #
      # ```
      # client.edit_user(4, {"email" => "icy.leaf@kaifeng.cn", "projects_limit" => "100"})
      # ```
      def edit_user(user_id : Int32, form : Hash = {} of String => String) : JSON::Any
        JSON.parse put("/users/#{user_id.to_s}", form: form).body
      end

      # Deletes a user.
      #
      # - param [Int32] user_id The ID of a user.
      # - return [Hash] Information about deleted user.
      #
      # ```
      # client.delete_user(1)
      # ```
      def delete_user(user_id : Int32) : JSON::Any
        JSON.parse delete("/users/#{user_id.to_s}").body
      end

      # Search for user by name
      #
      # - param  [String] query A string to search for in group names and paths.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :per_page Number of projects to return per page
      # - option params [String] :page The page to retrieve
      # - return [Array<Hash>] List of projects under search qyery
      #
      # ```
      # client.group_search("icyleaf")
      # client.group_search("icyleaf", {"per_page" => 50})
      # ```
      def user_search(query, params : Hash = {} of String => String) : JSON::Any
        JSON.parse get("/users", params: {"search" => query}.merge(params)).body
      end

      # Blocks the specified user.
      #
      # **Available only for admin**.
      #
      # - param [Int32] user_id The Id of user
      # - return [Hash] success or not
      #
      # ```
      # client.block_user(4)
      # ```
      def block_user(user_id : Int32) : JSON::Any
        JSON.parse put("/users/#{user_id.to_s}/block").body
      end

      # Unblocks the specified user.
      #
      # **Available only for admin**.
      #
      # - param [Int32] user_id The Id of user
      # - return [Hash] success or not
      #
      # ```
      # client.unblock_user(4)
      # ```
      def unblock_user(user_id : Int32) : JSON::Any
        JSON.parse put("/users/#{user_id.to_s}/unblock").body
      end

      # Gets a list of current user"s SSH keys.
      #
      # - return [Array<Hash>]
      #
      # ```
      # client.ssh_keys
      # ```
      def ssh_keys : JSON::Any
        JSON.parse get("/user/keys").body
      end

      # Gets a list of a user"s SSH keys.
      #
      # - param  [Int32] user_id The Id of user.
      # - return [Array<Hash>]
      #
      # ```
      # client.ssh_keys(4)
      # ```
      def ssh_keys(user_id : Int32) : JSON::Any
        JSON.parse get("/users/#{user_id.to_s}/keys").body
      end

      # Gets information about SSH key.
      #
      # - param  [Int32] ssh_key_id The ID of a user"s SSH key.
      # - return [Hash]
      #
      # ```
      # client.ssh_key(1)
      # ```
      def ssh_key(ssh_key_id : Int32) : JSON::Any
        JSON.parse get("/user/keys/#{ssh_key_id.to_s}").body
      end

      # Creates a new SSH key for current user.
      #
      # - param  [String] title The title of an SSH key.
      # - param  [String] key The SSH key body.
      # - return [Hash] Information about created SSH key.
      #
      # ```
      # client.create_ssh_key("key title", "key body")
      # ```
      def create_ssh_key(title, key) : JSON::Any
        JSON.parse post("/user/keys", form: {"title" => title, "key" => key}).body
      end

      # Creates a new SSH key for a user.
      #
      # - param  [Int32] user_id The Id of user.
      # - param  [String] key The SSH key body.
      # - return [Hash] Information about created SSH key.
      #
      # ```
      # client.create_ssh_key(2, "key title", "key body")
      # ```
      def create_ssh_key(user_id, title, key) : JSON::Any
        JSON.parse post("/users/#{user_id.to_s}/keys", form: {"title" => title, "key" => key}).body
      end

      # Deletes an SSH key for current user.
      #
      # - param  [Int32] ssh_key_id The ID of a user"s SSH key.
      # - return [Hash] Information about deleted SSH key.
      #
      # ```
      # client.delete_ssh_key(1)
      # ```
      def delete_ssh_key(ssh_key_id : Int32) : JSON::Any
        JSON.parse delete("/user/keys/#{ssh_key_id.to_s}").body
      end

      # Deletes an SSH key for a user.
      #
      # - param  [Int32] user_id The Id of user.
      # - param  [Int32] ssh_key_id The ID of a user"s SSH key.
      # - return [Hash] Information about deleted SSH key.
      #
      # ```
      # client.delete_ssh_key(1, 1)
      # ```
      def delete_ssh_key(user_id : Int32, ssh_key_id : Int32) : JSON::Any
        JSON.parse delete("/users/#{user_id.to_s}/keys/#{ssh_key_id.to_s}").body
      end

      # Gets current user emails.
      #
      # - return [Hash]
      #
      # ```
      # client.emails
      # ```
      def emails : JSON::Any
        JSON.parse get("/user/emails").body
      end

      # Gets a user emails.
      #
      # - param  [Int32] user_id The ID of a user.
      # - return [Hash]
      #
      # ```
      # client.emails(2)
      # ```
      def emails(user_id : Int32) : JSON::Any
        JSON.parse get("/users/#{user_id.to_s}/emails").body
      end

      # Get a single email.
      #
      # - param  [Int32] email_id The ID of a email.
      # - return [Hash]
      #
      # ```
      # client.email(3)
      # ```
      def email(email_id : Int32) : JSON::Any
        JSON.parse get("/user/emails/#{email_id.to_s}").body
      end

      # Creates a new email for current user.
      #
      # - params  [String] email Email address
      # - return [Hash]
      #
      # ```
      # client.add_email('email@example.com')
      # ```
      def add_email(email) : JSON::Any
        JSON.parse post("/user/emails", form: {"email" => email}).body
      end

      # Creates a new email for a user.
      #
      # - params  [Int32] user_id The ID of a user.
      # - params  [String] email Email address
      # - return [Hash]
      #
      # ```
      # client.add_email('email@example.com', 2)
      # ```
      def add_email(user_id : Int32, email) : JSON::Any
        JSON.parse post("/users/#{user_id.to_s}/emails", form: {"email" => email}).body
      end

      # Delete email for current user
      #
      # - params  [Int32] email_id Email address ID
      # - return [Hash]
      #
      # ```
      # client.delete_email(2)
      # ```
      def delete_email(email_id : Int32) : JSON::Any
        JSON.parse delete("/user/emails/#{email_id.to_s}").body
      end

      # Delete email for current user
      #
      # - params  [Int32] user_id The ID of a user.
      # - params  [Int32] email_id Email address ID
      # - return [Hash]
      #
      # ```
      # client.delete_email(1, 2)
      # ```
      def delete_email(email_id : Int32, user_id : Int32) : JSON::Any
        JSON.parse delete("/users/#{user_id.to_s}/emails/#{email_id.to_s}").body
      end
    end
  end
end
