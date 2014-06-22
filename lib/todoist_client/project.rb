module TodoistClient
  class Project
    include ApiClient

    VALID_PARAMS = [
      :user_id,
      :name,
      :color,
      :collapsed,
      :item_order,
      :cache_count,
      :indent,
      :id,
      :last_updated
    ].freeze

    attr_accessor *VALID_PARAMS

    module Paths
      ALL = [:get, "/API/getProjects"]
      FIND = [:get, "/API/getProject"]
      ADD = [:get, "/API/addProject"]
      UPDATE = [:get, "/API/updateProject"]
      DELETE = [:get, "/API/deleteProject"]
      ARCHIVE = [:get, "/API/archiveProject"]
      UNARCHIVE = [:get, "/API/unarchiveProject"]
    end

    def initialize(params = nil)
      case
      when params.is_a?(String)
        @name = params
      when params.is_a?(Hash)
        set_params(params)
      end
    end

    def save
      if id
        json = self.class.request *Paths::UPDATE, {
          project_id: @id, # required
          name: @name,
          color: @color,
          indent: @indent,
          order: @item_order
        }.select {|k,v| !v.nil?}
      else
        json = self.class.request *Paths::ADD, {
          name: @name, # required
          color: @color,
          indent: @indent,
          order: @item_order
        }.select {|k,v| !v.nil?}
      end
      set_params(json)
      self
    end

    def delete
      with_remote_object do
        self.class.request *Paths::DELETE, {project_id: id}
      end
    end

    # only premium user
    def archive
      with_remote_object do
        self.class.request *Paths::ARCHIVE, {project_id: id}
      end
    end

    # only premium user
    def unarchive
      with_remote_object do
        self.class.request *Paths::UNARCHIVE, {project_id: id}
      end
    end

    def uncompleted_items
      with_remote_object do
        Item.uncompleted(id)
      end
    end

    # only premium user
    def completed_items
      with_remote_object do
        Item.completed_items(id)
      end
    end

    class << self
      def all
        request(*Paths::ALL).map {|project| self.new(project)}
      end

      def find(id)
        self.new(request(*Paths::FIND, {project_id: id}))
      end

      def create(params)
        self.new(params).save
      end
    end
  end
end
