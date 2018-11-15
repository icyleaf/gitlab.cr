module Gitlab
  class Client
    # Defines methods related to version
    #
    # See [https://docs.gitlab.com/ce/api/version.html](https://docs.gitlab.com/ce/api/version.html)
    module Version
      # Returns server version.
      #
      # - return [JSON::Any]
      #
      # ```
      # client.version
      # ```
      def version
        get("/version").parse
      end
    end
  end
end
