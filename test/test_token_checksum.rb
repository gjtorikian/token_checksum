# frozen_string_literal: true

require "test_helper"

class TestTokenChecksum < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil(::TokenChecksum::VERSION)
  end

  def test_it_is_40_characters_long
    assert_equal(40, TokenChecksum.generate("xxx").length)
  end

  def test_has_correct_prefix
    assert_equal("wow", TokenChecksum.generate("wow")[0...3])
  end

  def test_validation
    secret = "test_secret"
    token = TokenChecksum.generate("rip", secret: secret)

    refute(TokenChecksum.valid?(token))
    refute(TokenChecksum.valid?(token + "x"))
    assert(TokenChecksum.valid?(token, secret: secret))
    refute(TokenChecksum.valid?(token + "x", secret: secret))
  end
end
