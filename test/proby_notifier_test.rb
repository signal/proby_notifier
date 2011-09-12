require 'test_helper'

class ProbyNotifierTest < Test::Unit::TestCase

  def setup
    ENV['PROBY_TASK_ID'] = nil
    FakeWeb.clean_registry
  end

  should "not send the notification if the api_key is not set" do
    assert_nil ProbyNotifier.send_start_notification("abc123")
  end

  context "with an api key set" do
    setup do
      ProbyNotifier.api_key = '1234567890abcdefg'
    end

    should "not send the notification if a task id was not specified" do
      assert_nil ProbyNotifier.send_start_notification
    end

    should "not send the notification if a task id is blank" do
      assert_nil ProbyNotifier.send_start_notification("  ")
    end

    should "send a start notification if a task_id is specified in the call" do
      FakeWeb.register_uri(:post, "https://proby.signalhq.com/tasks/abc123xyz456/start", :status => ["200", "Success"])
      assert_equal 200, ProbyNotifier.send_start_notification("abc123xyz456")
    end

    should "send a start notification if a task_id is specified in an environment variable" do
      ENV['PROBY_TASK_ID'] = "uuu777sss999"
      FakeWeb.register_uri(:post, "https://proby.signalhq.com/tasks/uuu777sss999/start", :status => ["200", "Success"])
      assert_equal 200, ProbyNotifier.send_start_notification
    end

    should "send a finish notification if a task_id is specified in the call" do
      FakeWeb.register_uri(:post, "https://proby.signalhq.com/tasks/abc123xyz456/finish", :status => ["200", "Success"])
      assert_equal 200, ProbyNotifier.send_finish_notification("abc123xyz456")
    end

    should "send a finish notification if a task_id is specified in an environment variable" do
      ENV['PROBY_TASK_ID'] = "iii999ooo222"
      FakeWeb.register_uri(:post, "https://proby.signalhq.com/tasks/iii999ooo222/finish", :status => ["200", "Success"])
      assert_equal 200, ProbyNotifier.send_finish_notification
    end
  end

end
