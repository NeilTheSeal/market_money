class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_params_response

  private

  def not_found_response(exception)
    error_message = ErrorMessage.new(exception.message, 404)
    serializer = ErrorSerializer.new
    serializer.add_error(error_message)
    render json: serializer.serialize_json, status: 404
  end

  def invalid_params_response(exception)
    serializer = ErrorSerializer.new
    exception.record.errors.errors.each do |error|
      error_message = ErrorMessage.new(
        "#{error.attribute} can't be blank", 400
      )
      serializer.add_error(error_message)
    end
    render json: serializer.serialize_json, status: 400
  end
end
