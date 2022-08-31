# TokenChecksum

Generates a 30 character long random token, with a prefix and a 32-bit checksum in the last 6 digits. Inspired by:

* https://github.blog/2021-04-05-behind-githubs-new-authentication-token-formats/
* https://github.com/stefansundin/token-checksum
* https://github.com/alexanderschau/access_token


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add token_checksum

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install token_checksum

## Usage

```ruby
token_one = TokenChecksum.generate("xoxo")
# "xoxo_3Q8oOwJyFzbuUaYIv2CPyu12K6gjmy2O8PIK"

# highly recommended that you introduce a secret as well
token_two = TokenChecksum.generate("xoxo", secret: "foo")
# "xoxo_4ftnAniunUKy6x0V75sMVg1VerpU2y1FoRT2"

# can also validate checksums
TokenChecksum.valid?(token_one)
# true

TokenChecksum.valid?(token_two, secret: "foo")
# true

TokenChecksum.valid?(token_two, secret: "bleh")
# FALSE
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
