class ErrorSerializer
  def initialize
    @errors = []
  end

  def serialize_json
    {
      errors: @errors.map do |error|
        {
          detail: error
        }
      end
    }
  end

  def add_error(error_message)
    @errors << error_message.message
  end
end
