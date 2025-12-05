struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: (ranges: [ClosedRange<Int>], ingredients: [Int]) {
    let parts = data.split(separator: "\n\n").map { String($0) } // file in two parts, separated by blank line

    let freshRangeStrs = parts.first!.split(separator: "\n").map { String($0) }
    let freshRanges = freshRangeStrs.map { rangeStr in 
      // for each line, convert to closed range (incl.)
      let bounds = rangeStr.split(separator: "-").map { Int($0)! }
      return bounds.first!...bounds.last!
    }

    let ingredientIds = parts.last!.split(separator: "\n").map { Int($0)! }

    return (freshRanges, ingredientIds)
  }

  func isFresh(ingredient id: Int, ranges: [ClosedRange<Int>]) -> Bool {
    // returns true if ingredient is in any of the ranges, false otherwise 
    for range in ranges {
      if range.contains(id) { return true }
    }
    return false
  }

  func mergeOverlaps(ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    // merges ranges that overlap into a single range
    var merged: [ClosedRange<Int>] = []

    // sort for easier merging
    let sorted = ranges.sorted { r1, r2 in
      if r1.lowerBound == r2.lowerBound {
        return r1.upperBound < r2.upperBound
      } else {
        return r1.lowerBound < r2.lowerBound
      }
    }

    for i in 0..<sorted.count {
      if merged.isEmpty { // initialize
        merged.append(sorted[i])
      } else {
        let recentMerge = merged.last! // get the most recently merged range
        if recentMerge.overlaps(sorted[i]) {
          // if most recent overlaps with current, then we can merge
          let minStart = min(recentMerge.lowerBound, sorted[i].lowerBound)
          let maxEnd = max(recentMerge.upperBound, sorted[i].upperBound)
          
          merged.removeLast() // re-merge
          merged.append(minStart...maxEnd)
        } else {
          // otherwise, add the current range to merged as-is
          merged.append(sorted[i])
        }
      }
    }

    return merged
  }

  func part1() -> Any {
    entities.ingredients.reduce(0) { acc, currIngredient in
      acc + (isFresh(ingredient: currIngredient, ranges: entities.ranges) ? 1 : 0)
    }
  }

  func part2() -> Any {
    mergeOverlaps(ranges: entities.ranges).reduce(0) { acc, range in acc + range.count }
  }
}
