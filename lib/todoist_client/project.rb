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
      # ARCHIVE = [:get, "/API/archiveProject"]
      # UNARCHIVE = [:get, "/API/unarchiveProject"]
    end

    def initialize(params = nil)
      set_params(params) if params
    end

    def save
      if id
        json = self.class.request *Paths::UPDATE, {
          project_id: id,
          name: name,
          color: color,
          indent: indent,
          order: item_order
        }
      else
        json = self.class.request *Paths::ADD, {
          name: name,
          color: color,
          indent: indent,
          order: item_order
        }
      end
      set_params(json)
    end

    def delete
      self.class.request *Paths::DELETE, {project_id: id} if id
    end

    # def archive
    #   self.class.request *Paths::ARCHIVE, {project_id: id} if id
    # end

    # def unarchive
    #   self.class.request *Paths::UNARCHIVE, {project_id: id} if id
    # end

    def uncompleted_items
      Item.uncompleted(id) if id
    end

    def completed_items
      Item.completed(id) if id
    end

    def set_params(params)
      params.each do |k,v|
        self.send "#{k}=", v if self.respond_to? "#{k}="
      end
    end

    class << self
      def all
        request(*Paths::ALL).map {|project| self.new(project)}
      end

      def find(id)
        self.new(request(*Paths::FIND, {project_id: id}))
      end

      def create(name)
        self.new(name).save
      end
    end
  end
end
