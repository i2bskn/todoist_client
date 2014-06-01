module TodoistClient
  class TodoistClientError < StandardError; end
  class NoApiToken < TodoistClientError; end
end
