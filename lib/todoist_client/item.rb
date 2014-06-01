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
      FIND = [:get, "/API/getItemsById"]
      ADD = [:get, "/API/addItem"]
      UPDATE = [:get, "/API/updateItem"]
      DELETE = [:get, "/API/deleteItems"]
      COMPLETE = [:get, "/API/completeItems"]
      UNCOMPLETE = [:get, "/API/uncompleteItems"]
    end

    def initialize(params = nil)
      set_params(params) if params
    end

    def save
      if id
        json = self.class.request *Paths::UPDATE, {
          id: id,
          content: content
        }
      else
        json = self.class.request *Paths::ADD, {
          content: content,
          project_id: project_id
        }
      end
      set_params(json)
    end

    def delete
      self.class.request *Paths::DELETE, {ids: JSON.generate([id])} if id
    end

    def complete
      self.class.request *Paths::COMPLETE, {ids: JSON.generate([id])} if id
    end

    def uncomplete
      self.class.request *Paths::UNCOMPLETE, {ids: JSON.generate([id])} if id
    end

    def set_params(params)
      params.each do |k,v|
        self.send "#{k}=", v if self.respond_to? "#{k}="
      end
    end

    class << self
      def uncompleted(project_id)
        request(*Paths::UNCOMPLETED, {project_id: project_id}).map { |item|
          self.new(item)
        }
      end

      def completed(project_id)
        request(*Paths::COMPLETED, {project_id: project_id}).map { |item|
          self.new(item)
        }
      end

      def find(ids)
        request(*Paths::FIND, {ids: json_ids(ids)}).map { |item|
          self.new(item)
        }
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
