module TodoistClient
  class TodoistClientError < StandardError; end
  class NoApiToken < TodoistClientError; end
  class RemoteObjectNotExists < TodoistClientError; end
end
