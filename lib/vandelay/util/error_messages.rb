module ErrorMessages
  ERROR_MESSAGES = {
    400 => "Bad request",
    401 => "Unauthorized",
    404 => "The resource you requested could not be found.",

    numeric_id_expected: "Invalid ID format. Expected numeric ID."
    # Add more as needed
  }.freeze

  def self.message_for(status_code)
    ERROR_MESSAGES[status_code] || "Unknown error"
  end
end
