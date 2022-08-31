# frozen_string_literal: true

require "test_helper"

class TestBase62 < Minitest::Test
  def test_that_it_works
    random_uuid = "7e382b77-68f6-4022-a43f-1f12b74786ed"
    str = random_uuid.split("-").join.to_i(16)
    result = TokenChecksum::Base62.encode(str)
    assert_equal("3qAhZol0YjoXVoMD3azk45", result)
  end
end
