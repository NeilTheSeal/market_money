class ErrorSerializer
  def self.invalid_id(type, id)
    {
      errors: [
        {
          detail: "Couldn't find #{type} with 'id'=#{id}"
        }
      ]
    }
  end
end
