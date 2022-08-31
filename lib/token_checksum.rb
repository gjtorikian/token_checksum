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
      suffix = random_token
      first_part = "#{prefix}_#{suffix}"
      checksum = generate_checksum("#{first_part}#{secret}")
      "#{first_part}#{checksum}"
    end

    def valid?(token, valid_prefixes: [], secret: "")
      return false if token.empty?

      provided_prefix = prefix(token)
      return false if !valid_prefixes.empty? && !valid_prefixes.include?(provided_prefix)

      provided_checksum = checksum(token)
      return false if provided_checksum.empty?

      # This is the token without the final checksum
      checksumless_string = wo_checksum(token)
      return false if checksumless_string.empty?

      calculated_checksum = generate_checksum("#{checksumless_string}#{secret}")

      SecureCompare.compare(calculated_checksum, provided_checksum)
    end

    def prefix(token)
      token[0...token.index("_")]
    end

    def checksum(token)
      token[-6..-1]
    end

    def wo_checksum(token)
      token[0..-7]
    end

    private def random_token
      (random_base62 + random_base62)[0...30]
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
