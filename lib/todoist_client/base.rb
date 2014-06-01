module TodoistClient
  @api_token

  module Base
    def api_token
      @api_token
    end

    def api_token=(token)
      @api_token = token
    end
  end

  extend Base
end
