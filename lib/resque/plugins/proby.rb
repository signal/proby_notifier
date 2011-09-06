module ProbyNotifier
  module Resque::Plugins
    # Automatically notifies Proby when this job starts and finishes.
    #
    #   class SomeJob
    #     extend ProbyNotifier::Resque::Plugins::Proby
    #
    #     self.perform
    #       do_stuff
    #     end
    #   end
    #
    # The Proby Task ID can be set in one of two ways. The most common way is to
    # put the ID in an ENV variable that is set in your crontab. This ID will be
    # transparently passed to the Resque job via Redis.
    #
    #   0 0 * * * PROBY_TASK_ID=abc123 ./queue_some_job
    #
    # Alternatively, if you're not using cron and therefore don't want that
    # support, you can just set the @proby_id ivar in the class, like so.
    #
    #   class SomeJob
    #     extend ProbyNotifier::Resque::Plugins::Proby
    #     @proby_id = 'abc123'
    #
    #     self.perform
    #       do_stuff
    #     end
    #   end
    #
    # Setting the @proby_id variable will take precendence over the ENV variable.
    #
    module Proby
      def proby_id_bucket(*args)
        "proby_id:#{name}-#{args.to_s}"
      end

      def before_enqueue_proby(*args)
        return true if @proby_id

        env_proby_id = ENV['PROBY_TASK_ID']
        Resque.redis.setex(proby_id_bucket(*args), 24.hours, env_proby_id)
        return true
      end

      def proby_id(*args)
        @proby_id || Resque.redis.get(proby_id_bucket(*args))
      end

      def around_perform_proby(*args)
        _proby_id = proby_id(*args)
        ProbyNotifier.send_start_notification(_proby_id)
        yield
      ensure
        ProbyNotifier.send_finish_notification(_proby_id)
      end
    end
  end
end
