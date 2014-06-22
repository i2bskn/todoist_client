module TodoistClient
  class Item
    include ApiClient

    VALID_PARAMS = [
      :due_date,
      :user_id,
      :collapsed,
      :in_history,
      :priority,
      :item_order,
      :content,
      :indent,
      :project_id,
      :id,
      :checked,
      :date_string
    ].freeze

    attr_accessor *VALID_PARAMS

    module Paths
      UNCOMPLETED = [:get, "/API/getUncompletedItems"]
      COMPLETED = [:get, "/API/getCompletedItems"]
      ALL_COMPLETED = [:get, "/API/getAllCompletedItems"]
      FIND = [:get, "/API/getItemsById"]
      ADD = [:get, "/API/addItem"]
      UPDATE = [:get, "/API/updateItem"]
      DELETE = [:get, "/API/deleteItems"]
      COMPLETE = [:get, "/API/completeItems"]
      UNCOMPLETE = [:get, "/API/uncompleteItems"]
    end

    def initialize(params = nil)
      case
      when params.is_a?(String)
        @content = params
      when params.is_a?(Hash)
        set_params(params)
      end
    end

    def save
      if id
        json = self.class.request *Paths::UPDATE, {
          id: @id, # required
          content: @content,
          priority: @priority,
          indent: @indent,
          item_order: @item_order,
          collapsed: @collapsed
        }.select {|k,v| !v.nil?}
      else
        json = self.class.request *Paths::ADD, {
          content: @content, # required
          project_id: @project_id,
          date_string: @date_string,
          priority: @priority,
          indent: @indent,
          item_order: @item_order
        }.select {|k,v| !v.nil?}
      end
      set_params(json)
      self
    end

    def delete
      with_remote_object do
        self.class.request *Paths::DELETE, {ids: JSON.generate([id])}
      end
    end

    def complete
      with_remote_object do
        self.class.request *Paths::COMPLETE, {ids: JSON.generate([id])}
      end
    end

    def uncomplete
      with_remote_object do
        self.class.request *Paths::UNCOMPLETE, {ids: JSON.generate([id])}
      end
    end

    def finished?
      checked == 1
    end

    class << self
      def uncompleted(project)
        project_id = project.is_a?(Project) ? project.id : project
        request(*Paths::UNCOMPLETED, {project_id: project_id}).map {|item| self.new(item)}
      end

      def completed(project)
        project_id = project.is_a?(Project) ? project.id : project
        request(*Paths::COMPLETED, {project_id: project_id}).map {|item| self.new(item)}
      end

      # only premium user
      def completed_items(project = nil)
        project_id = project.is_a?(Project) ? project.id : project
        request(*Paths::ALL_COMPLETED, {project_id: project_id})["items"].map {|item|
          CompletedItem.new(item)
        }
      end

      def find(ids)
        items = request(*Paths::FIND, {ids: json_ids(ids)}).map {|item| self.new(item)}
        # return nil or Item object if item does not exist multiple.
        items.size > 1 ? items : items.first
      end

      def create(params)
        self.new(params).save
      end

      def delete_all(ids)
        request *Paths::DELETE, {ids: json_ids(ids)}
      end

      def complete_all(ids)
        request *Paths::COMPLETE, {ids: json_ids(ids)}
      end

      def uncomplete_all(ids)
        request *Paths::UNCOMPLETE, {ids: json_ids(ids)}
      end

      def json_ids(ids)
        ids = [ids] unless ids.is_a?(Array)
        JSON.generate(ids)
      end
    end
  end
end
