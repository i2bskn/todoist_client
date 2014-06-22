module TodoistClient
  module ApiClient
    BASE_URI = "https://api.todoist.com"

    def self.included(klass)
      klass.extend ClassMethods
    end

    def with_remote_object(&block)
      if id
        block.call if block_given?
      else
        raise RemoteObjectNotExists
      end
    end

    def set_params(params)
      params.each do |k,v|
        self.send "#{k}=", v if self.respond_to? "#{k}="
      end
    end

    module ClassMethods
      def request(method, endpoint, params = nil)
        JSON.load RestClient.send(method, "#{BASE_URI}#{endpoint}", query_string(params))
      end
      
      def query_string(params = nil)
        raise NoApiToken unless TodoistClient.api_token
        params ||= {}
        {
          params: {
            token: TodoistClient.api_token
          }.merge(params)
        }
      end
    end
  end
end
