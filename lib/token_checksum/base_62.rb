# frozen_string_literal: true

module TokenChecksum
  module Base62
    PRIMITIVES = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] + \
      ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"] + \
      ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    PRIMITIVES_SIZE = 62

    class << self
      def encode(int, min_length: 0)
        return "".rjust(min_length, PRIMITIVES[0]) if int <= 0

        result = ""
        while int > 0
          result = PRIMITIVES[int % PRIMITIVES_SIZE] + result
          int /= PRIMITIVES_SIZE
        end

        result.rjust(min_length, PRIMITIVES[0])
      end
    end
  end
end
