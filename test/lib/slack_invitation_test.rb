require 'test_helper'

class SlackInvitationTest < ActiveSupport::TestCase

  def setup
    SlackInvitation.stubs(:token).returns('abcd')
  end

  test "it has the base URI set to slack.com" do
    assert_includes SlackInvitation.base_uri, 'slack.com/api'
  end

  test "it generates the correct query params for invitations" do
    params = SlackInvitation.new('foo@bar.com', 'FirstName', 'LastName').query
    assert_includes params, 'email=foo%40bar.com'
    assert_includes params, 'first_name=FirstName'
    assert_includes params, 'last_name=LastName'
    assert_includes params, "token=abcd"
    assert_includes params, 'set_active=true'
  end

  test "it was successful if it returns ok" do
    stub_request(:get, /slack.com/)
      .to_return({
        body: { ok: true }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      })

    request = SlackInvitation.deliver('foo@bar.com', 'first', 'last')
    assert request.successful?
  end
end
