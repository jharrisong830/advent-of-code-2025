import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [ClosedRange<Int>] {
    data.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").map { 
      String($0).split(separator: "-").map { String($0) }
    }.map { Int($0.first!)!...Int($0.last!)! }
  }

  func isIdInvalid(_ id: Int) -> Bool {
    // checks if string is invalid (if first half matches second half)
    let str = String(id)
    let mid = str.index(str.startIndex, offsetBy: str.count / 2)
    let firstHalf = str[str.startIndex..<mid]
    let secondHalf = str[mid..<str.endIndex]
    return firstHalf == secondHalf // invalid if string repeats 
  }

  func isIdInvalid_part2(_ id: Int) -> Bool {
    // checks if string is invalid (if has a pattern that repeats any amount of times)
    let str = String(id)
    if str.count == 1 { // single character cannot be invalid
      return false
    }
    else if str.allSatisfy({ $0 == str[str.startIndex] }) { // all same characters repeating
      return true 
    } else if str.count <= 3 { // cannot be invalid unless all are same character (would be checked by previous case)
      return false 
    }

    // split string into evenly sized groups up to (not including) half the string length
    for chunkCount in 2..<(str.count / 2) {
      if str.count % chunkCount != 0 { continue } // only check lengths that divide evenly
      let chunks = str.chunks(ofCount: chunkCount)
      if chunks.allSatisfy({ $0 == chunks.first! }) {
        return true
      }
    }

    // finally, check the case where the first half matches the second half (part 1 rules)
    return isIdInvalid(id)
  }

  func part1() -> Any {
    entities.reduce(0) { acc, range in // for each range...
      // filter to only even-length ids (only ones possible of being invalid),
      // then filter to only invalid ids,
      // then sum invalid id values,
      // then add to accumulator
      acc + range.filter { String($0).count % 2 == 0 }.filter { isIdInvalid($0) }.reduce(0, +) // sum invalid ids in range
    }
  }

  func part2() -> Any {
    entities.reduce(0) { acc, range in // for each range...
      // filter to only invalid ids (based on new part 2 rules),
      // then sum invalid id values,
      // then add to accumulator
      acc + range.filter { isIdInvalid_part2($0) }.reduce(0, +) // sum invalid ids in range
    }
  }
}
