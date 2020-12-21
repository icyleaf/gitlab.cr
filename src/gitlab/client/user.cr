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
      # - return [JSON::Any]
      #
      # ```
      # client.users
      # client.users({"per_page" => "10", "page" => "2"})
      # ```
      def users(params : Hash? = nil) : JSON::Any
        get("users", params: params).parse
      end

      # Gets information about current user.
      #
      # - return [JSON::Any]
      #
      # ```
      # client.user
      # ```
      def user : JSON::Any
        get("user").parse
      end

      # Gets information about a user.
      #
      # - param  [Int32] user_id The ID of a user.
      # - return [JSON::Any]
      #
      # ```
      # client.user(2)
      # ```
      def user(user_id : Int32) : JSON::Any
        get("users/#{user_id.to_s}").parse
      end

      # Creates a new user.
      # Requires authentication from an admin account.
      #
      # - param  [String] email The email of a user.
      # - param  [String] password The password of a user.
      # - param  [String] username The username of a user.
      # - param  [Hash] form A customizable set of form.
      # - option form [String] :name The name of a user. Defaults to email.
      # - option form [String] :skype The skype of a user.
      # - option form [String] :linkedin The linkedin of a user.
      # - option form [String] :twitter The twitter of a user.
      # - option form [Int32] :projects_limit The limit of projects for a user.
      # - return [JSON::Any] Information about created user.
      #
      # ```
      # Gitlab.create_user("icy.leaf@kaifeng.cn", "secret", "icyleaf", {"name" => "三火"})
      # Gitlab.create_user("icy.leaf@kaifeng.cn", "secret", "icyleaf")
      # ```
      def create_user(email : String, password : String, username : String, form : Hash = {} of String => String) : JSON::Any
        post("users", form: {
          "email"    => email,
          "password" => password,
          "username" => username,
          "name"     => username,
        }.merge(form)).parse
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
      # - return [JSON::Any] Information about edit user.
      #
      # ```
      # client.edit_user(4, {"email" => "icy.leaf@kaifeng.cn", "projects_limit" => "100"})
      # ```
      def edit_user(user_id : Int32, form : Hash = {} of String => String) : JSON::Any
        put("users/#{user_id.to_s}", form: form).parse
      end

      # Deletes a user.
      #
      # - param [Int32] user_id The ID of a user.
      # - return [JSON::Any] Information about deleted user.
      #
      # ```
      # client.delete_user(1)
      # ```
      def delete_user(user_id : Int32) : JSON::Any | Bool
        response = delete("users/#{user_id.to_s}")
        return true if response.status_code == 204
        response.parse
      end

      # Search for user by name
      #
      # - param  [String] query A string to search for in group names and paths.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :per_page Number of projects to return per page
      # - option params [String] :page The page to retrieve
      # - return [JSON::Any] List of projects under search qyery
      #
      # ```
      # client.group_search("icyleaf")
      # client.group_search("icyleaf", {"per_page" => 50})
      # ```
      def user_search(query, params : Hash = {} of String => String) : JSON::Any
        get("users", params: {"search" => query}.merge(params)).parse
      end

      # List user custom attributes
      #
      # **Available only for admin**.
      #
      # - param [Int32] user_id The Id of user
      # - return [JSON::Any] information about the custom_attribute
      #
      # ```
      # client.user_custom_attributes(4)
      # ```
      def user_custom_attributes(user_id : Int32 ) : JSON::Any
        get("users/#{user_id.to_s}/custom_attributes").parse
      end

      # Add's a user custom attribute
      #
      # **Available only for admin**.
      #
      # - param [Int32] user_id The Id of user
      # - param [String] the key of the custom attribute
      # - param  [Hash] params A single param with the value of the custom attribute
      # - params [String] :value The value of the custom attribute.
      # - return [JSON::Any] information about the custom_attribute
      #
      # ```
      # client.user_add_custom_attribute(4, custom_key, {"value"=> "custom_value"})
      # ```
      def user_add_custom_attribute(user_id : Int32, key : String, params : Hash = {} of String => String ) : JSON::Any
        put("users/#{user_id.to_s}/custom_attributes/#{key}", form: params).parse
      end

      # Deletes a user custom attribute
      #
      # **Available only for admin**.
      #
      # - param [Int32] user_id The Id of user
      # - param [String] the key of the custom attribute
      # - return [JSON::Any] information about the custom_attribute
      #
      # ```
      # client.user_delete_custom_attribute(4, custom_key)
      # ```
      def user_delete_custom_attribute(user_id : Int32, key : String) : JSON::Any | Bool
        response = delete("users/#{user_id.to_s}/custom_attributes/#{key}")
        return true if response.status_code == 204
        response.parse
      end

      # Blocks the specified user.
      #
      # **Available only for admin**.
      #
      # - param [Int32] user_id The Id of user
      # - return [JSON::Any] success or not
      #
      # ```
      # client.block_user(4)
      # ```
      def block_user(user_id : Int32) : JSON::Any
        put("users/#{user_id.to_s}/block").parse
      end

      # Unblocks the specified user.
      #
      # **Available only for admin**.
      #
      # - param [Int32] user_id The Id of user
      # - return [JSON::Any] success or not
      #
      # ```
      # client.unblock_user(4)
      # ```
      def unblock_user(user_id : Int32) : JSON::Any
        put("users/#{user_id.to_s}/unblock").parse
      end

      # Gets a list of current user"s SSH keys.
      #
      # - return [JSON::Any]
      #
      # ```
      # client.ssh_keys
      # ```
      def ssh_keys : JSON::Any
        get("user/keys").parse
      end

      # Gets a list of a user"s SSH keys.
      #
      # - param  [Int32] user_id The Id of user.
      # - return [JSON::Any]
      #
      # ```
      # client.ssh_keys(4)
      # ```
      def ssh_keys(user_id : Int32) : JSON::Any
        get("users/#{user_id.to_s}/keys").parse
      end

      # Gets information about SSH key.
      #
      # - param  [Int32] ssh_key_id The ID of a user"s SSH key.
      # - return [JSON::Any]
      #
      # ```
      # client.ssh_key(1)
      # ```
      def ssh_key(ssh_key_id : Int32) : JSON::Any
        get("user/keys/#{ssh_key_id.to_s}").parse
      end

      # Creates a new SSH key for current user.
      #
      # - param  [String] title The title of an SSH key.
      # - param  [String] key The SSH key body.
      # - return [JSON::Any] Information about created SSH key.
      #
      # ```
      # client.create_ssh_key("key title", "key body")
      # ```
      def create_ssh_key(title, key) : JSON::Any
        post("user/keys", form: {"title" => title, "key" => key}).parse
      end

      # Creates a new SSH key for a user.
      #
      # - param  [Int32] user_id The Id of user.
      # - param  [String] key The SSH key body.
      # - return [JSON::Any] Information about created SSH key.
      #
      # ```
      # client.create_ssh_key(2, "key title", "key body")
      # ```
      def create_ssh_key(user_id, title, key) : JSON::Any
        post("users/#{user_id.to_s}/keys", form: {"title" => title, "key" => key}).parse
      end

      # Deletes an SSH key for current user.
      #
      # - param  [Int32] ssh_key_id The ID of a user"s SSH key.
      # - return [JSON::Any] Information about deleted SSH key.
      #
      # ```
      # client.delete_ssh_key(1)
      # ```
      def delete_ssh_key(ssh_key_id : Int32) : JSON::Any | Bool
        response = delete("user/keys/#{ssh_key_id.to_s}")
        return true if response.status_code == 204
        response.parse
      end

      # Deletes an SSH key for a user.
      #
      # - param  [Int32] user_id The Id of user.
      # - param  [Int32] ssh_key_id The ID of a user"s SSH key.
      # - return [JSON::Any] Information about deleted SSH key.
      #
      # ```
      # client.delete_ssh_key(1, 1)
      # ```
      def delete_ssh_key(user_id : Int32, ssh_key_id : Int32) : JSON::Any | Bool
        response = delete("users/#{user_id.to_s}/keys/#{ssh_key_id.to_s}")
        return true if response.status_code == 204
        response.parse
      end

      # Gets current user emails.
      #
      # - return [JSON::Any]
      #
      # ```
      # client.emails
      # ```
      def emails : JSON::Any
        get("user/emails").parse
      end

      # Gets a user emails.
      #
      # - param  [Int32] user_id The ID of a user.
      # - return [JSON::Any]
      #
      # ```
      # client.emails(2)
      # ```
      def emails(user_id : Int32) : JSON::Any
        get("users/#{user_id.to_s}/emails").parse
      end

      # Get a single email.
      #
      # - param  [Int32] email_id The ID of a email.
      # - return [JSON::Any]
      #
      # ```
      # client.email(3)
      # ```
      def email(email_id : Int32) : JSON::Any
        get("user/emails/#{email_id.to_s}").parse
      end

      # Creates a new email for current user.
      #
      # - params  [String] email Email address
      # - return [JSON::Any]
      #
      # ```
      # client.add_email('email@example.com')
      # ```
      def add_email(email) : JSON::Any
        post("user/emails", form: {"email" => email}).parse
      end

      # Creates a new email for a user.
      #
      # - params  [Int32] user_id The ID of a user.
      # - params  [String] email Email address
      # - return [JSON::Any]
      #
      # ```
      # client.add_email('email@example.com', 2)
      # ```
      def add_email(user_id : Int32, email) : JSON::Any
        post("users/#{user_id.to_s}/emails", form: {"email" => email}).parse
      end

      # Delete email for current user
      #
      # - params  [Int32] email_id Email address ID
      # - return [JSON::Any]
      #
      # ```
      # client.delete_email(2)
      # ```
      def delete_email(email_id : Int32) : JSON::Any | Bool
        response = delete("user/emails/#{email_id.to_s}")
        return true if response.status_code == 204
        response.parse
      end

      # Delete email for current user
      #
      # - params  [Int32] user_id The ID of a user.
      # - params  [Int32] email_id Email address ID
      # - return [JSON::Any]
      #
      # ```
      # client.delete_email(1, 2)
      # ```
      def delete_email(email_id : Int32, user_id : Int32) : JSON::Any | Bool
        response = delete("users/#{user_id.to_s}/emails/#{email_id.to_s}")
        return true if response.status_code == 204
        response.parse
      end
    end
  end
end
