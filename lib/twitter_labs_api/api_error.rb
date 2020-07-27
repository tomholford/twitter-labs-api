module TwitterLabsAPI
  class APIError < StandardError
    DEFAULT_MESSAGE = 'Twitter Labs API error, check the response attribute'.freeze
  
    attr_reader :response
  
    def initialize(msg = DEFAULT_MESSAGE, response = nil)
      @response = response
  
      super(msg)
    end
  end  
end
