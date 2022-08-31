# frozen_string_literal: true

require_relative "token_checksum/base_62"
require_relative "token_checksum/version"

require "zlib"
require "securerandom"
require "securecompare"

if ENV.fetch("DEBUG", "false")
  require "debug"
end

module TokenChecksum
  REGEX = /([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]{1,})_([0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]{30})([0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]{6})/

  class << self
    def generate(prefix, secret: "")
      suffix = (random_base62 + random_base62)[0...30]
      first_part = "#{prefix}_#{suffix}"
      checksum = generate_checksum("#{first_part}#{secret}")
      "#{first_part}#{checksum}"
    end

    def valid?(token, secret: "")
      return false if token.empty?

      provided_checksum = token[-6..-1]
      return false if provided_checksum.empty?

      # This is the token without the final checksum
      checksumless_string = token[0..-7]
      return false if checksumless_string.empty?

      calculated_checksum = generate_checksum("#{checksumless_string}#{secret}")

      SecureCompare.compare(calculated_checksum, provided_checksum)
    end

    private def generate_checksum(string)
      checksum = Zlib.crc32(string)
      Base62.encode(checksum, min_length: 6)
    end

    private def random_base62
      Base62.encode(SecureRandom.uuid.delete("-").to_i(16))
    end
  end
end
