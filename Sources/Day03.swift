struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map { Array($0) }.map { $0.map { char in char.wholeNumberValue! } }
  }

  func getMaxSubsequence(arr: [Int], toRemove: Int) -> [Int] {
    // https://www.naukri.com/code360/library/lexicographically-largest-string-after-removal-of-k-characters
    var result: [Int] = []
    var k = toRemove

    for i in 0..<arr.count {
      while result.count > 0 && result.last! < arr[i] && k > 0 {
        result.removeLast()
        k -= 1
      }

      result.append(arr[i])
    }

    while result.count > 0 && k > 0 {
      result.removeLast()
      k -= 1
    }

    return result
  }

  func part1() -> Any {
    // proper way lol:
    entities.map { bank in 
      getMaxSubsequence(arr: bank, toRemove: bank.count - 2)
    }.map { joltArr in 
      joltArr.map { String($0) }.joined()
    }.map { Int($0)! }.reduce(0, +)

    // next version:
    // entities.map { bank in 
    //   // 2 digits kept in relative order
    //   bank.combinations(ofCount: 2).map { combo in // turn each sublist of ints into a string 
    //     combo.reduce("") { acc, curr in 
    //       acc + String(curr)
    //     }
    //   }.map { Int($0)! }.max()!
    // }.reduce(0, +)

    // original:
    // entities.map { bank in 
    //   let firstNum = bank.dropLast().max()!
    //   let splitPoint = bank.firstIndex(of: firstNum)!.advanced(by: 1)
    //   let rest = bank[splitPoint...]
    //   let secondNum = rest.max()!
    //   return Int(String(firstNum) + String(secondNum))!
    // }.reduce(0, +)
  }

  func part2() -> Any {
    entities.map { bank in 
      getMaxSubsequence(arr: bank, toRemove: bank.count - 12)
    }.map { joltArr in 
      joltArr.map { String($0) }.joined()
    }.map { Int($0)! }.reduce(0, +)
  }
}
