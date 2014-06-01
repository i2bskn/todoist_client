module TodoistClient
  module ApiClient
    BASE_URI = "https://api.todoist.com"

    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def request(method, endpoint, params = nil)
        p "#{BASE_URI}#{endpoint}"
        p query_string(params)
        JSON.load RestClient.send(method, "#{BASE_URI}#{endpoint}", query_string(params))
      end
      
      def query_string(params = nil)
        raise NoApiToken, "API Token not find" unless TodoistClient.api_token
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
