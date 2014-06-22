module TodoistClient
  # only premium user
  class CompletedItem
    include ApiClient

    VALID_PARAMS = [
      :content,
      :meta_data,
      :user_id,
      :task_id,
      :note_count,
      :project_id,
      :completed_date,
      :id
    ].freeze

    attr_accessor *VALID_PARAMS

    def initialize(params)
      raise ArgumentError if params["id"].nil?
      set_params(params)
    end

    def completed_date=(date_string)
      @completed_date = case
      when date_string.is_a?(String)
        Time.parse(date_string)
      when date_string.is_a?(Time)
        date_string
      else
        raise ArgumentError
      end
    end

    def to_item
      Item.find(@task_id)
    end
  end
end
