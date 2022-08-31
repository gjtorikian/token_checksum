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
    assert_equal("wow_", TokenChecksum.generate("wow")[0...4])
  end

  def test_validation
    secret = "test_secret"
    token = TokenChecksum.generate("rip", secret: secret)

    refute(TokenChecksum.valid?(token))
    refute(TokenChecksum.valid?(token + "x"))
    assert(TokenChecksum.valid?(token, secret: secret))
    refute(TokenChecksum.valid?(token + "x", secret: secret))
  end

  def test_works_for_short_prefixes
    short_token_prefix = "o"
    short_token = TokenChecksum.generate(short_token_prefix)
    # +1 added for underscore
    assert_equal(36, short_token.length - (short_token_prefix.length + 1))
    assert(TokenChecksum.valid?(short_token))
  end

  def test_works_for_long_prefixes
    long_token_prefix = "123456AAA"
    long_token = TokenChecksum.generate(long_token_prefix)
    # +1 added for underscore
    assert_equal(36, long_token.length - (long_token_prefix.length + 1))
    assert(TokenChecksum.valid?(long_token))
  end

  def test_regex_matching
    assert_match(TokenChecksum::REGEX, "xxx_1BpDK7DKPGCgc4EOmsq0mGIfw45XmS1ge36n")
    refute_match(TokenChecksum::REGEX, "!_1BpDK7DKPGCgc4EOmsq0mGIfw45XmS1ge36n")
    refute_match(TokenChecksum::REGEX, "xxx_1BpDK7DKPGCgc4EOmsq0mG!Ifaw45XmS1ge36")
    refute_match(TokenChecksum::REGEX, "xxx_1BpDK7DKPGCgc4EOmsq0_GIfw45XmS1ge36n")
  end
end
