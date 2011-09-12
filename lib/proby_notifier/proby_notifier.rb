require 'net/https'
require 'logger'

module ProbyNotifier

  BASE_URL = "https://proby.signalhq.com/tasks/"

  # Deliver start and finish notifications to Proby.
  class << self

    # Set your Proby API key.
    #
    # @param [String] api_key Your Proby API key
    #
    # @example
    #   ProbyNotifier.api_key = '1234567890abcdefg'
    def api_key=(api_key)
      @api_key = api_key
    end

    # Set the logger to be used by Proby.
    #
    # @param [Logger] logger The logger you would like ProbyNotifier to use
    #
    # @example
    #   ProbyNotifier.logger = Rails.logger
    #   ProbyNotifier.logger = Logger.new(STDERR)
    def logger=(logger)
      @logger = logger
    end

    # Get the logger used by Proby.
    def logger
      @logger || Logger.new("/dev/null")
    end

    # Send a start notification for this task to Proby.
    #
    # @param [String] proby_task_id The id of the task to be notified. If nil, the 
    #                               value of the +PROBY_TASK_ID+ environment variable will be used.
    def send_start_notification(proby_task_id=nil)
      send_notification('/start', proby_task_id)
    end

    # Send a finish notification for this task to Proby
    #
    # @param [String] proby_task_id The id of the task to be notified. If nil, the 
    #                               value of the +PROBY_TASK_ID+ environment variable will be used.
    def send_finish_notification(proby_task_id=nil)
      send_notification('/finish', proby_task_id)
    end

    private

    def send_notification(type, proby_task_id)
      if @api_key.nil?
        logger.warn "ProbyNotifier: API key not set"
        return nil
      end

      proby_task_id ||= ENV['PROBY_TASK_ID']
      if proby_task_id.nil?
        logger.warn "ProbyNotifier: Task ID not specified"
        return nil
      end

      url = BASE_URL + proby_task_id + type
      uri = URI.parse(url)
      req = Net::HTTP::Post.new(uri.path, {'api_key' => @api_key})

      http = Net::HTTP.new(uri.host, uri.port) 
      http.open_timeout = 3
      http.read_timeout = 3
      http.use_ssl = true
      res = http.start { |h| h.request(req) }
      return res.code.to_i
    rescue Exception => e
      logger.error "ProbyNotifier: Proby notification failed: #{e.message}"
      logger.error e.backtrace
    end
  end

end
