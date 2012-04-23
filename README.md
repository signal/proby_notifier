# ProbyNotifier
A simple library for working with the Proby task monitoring application.


Installation
------------

### RubyGems ###
ProbyNotifier can be installed using RubyGems

    gem install proby_notifier

Inside your script, be sure to

    require "rubygems"
    require "proby_notifier"

### Bundler ###
If you're using Bundler, add the following to your Gemfile

    gem 'proby_notifier'

and then run

    bundle install


Setup
-----
Before notifications can be sent, you must tell ProbyNotifier your API key.  This only needs to be done once,
and should ideally be done inside your apps initialization code.

    ProbyNotifier.api_key = "b4fe1200c105012efde3482a1411a947"

In addition, you can optionally give ProbyNotifier a logger to use.

    ProbyNotifier.logger = Rails.logger


Sending Notifications
---------------------
To send a start notification

    ProbyNotifier.send_start_notification(task_api_id)

To send a finish notification

    ProbyNotifier.send_finish_notification(task_api_id)

Specifying the `task_api_id` when calling the notification methods is optional.  If it is not provided,
ProbyNotifier will use the value of the `PROBY_TASK_ID` environment variable.  If no task id is specified
in the method call, and no value is set in the `PROBY_TASK_ID` environment variable, then no notification
will be sent.


The Resque Plugin
-----------------
The Resque plugin will automatically send start and finish notifications to Proby when your job
starts and finishes.  Simply `extend ProbyNotifier::ResquePlugin` in your Resque job.  The task id
can either be pulled from the `PROBY_TASK_ID` environment variable, or specified in the job itself
by setting the `@proby_id` attribute to the task id.

    class SomeJob
      extend ProbyNotifier::ResquePlugin
      @proby_id = 'abc123'  # Or simply let it use the value in the PROBY_TASK_ID environment variable

      self.perform
        do_stuff
      end
    end


API Doc
-------
[http://rdoc.info/github/signal/proby_notifier/master/frames](http://rdoc.info/github/signal/proby_notifier/master/frames)

