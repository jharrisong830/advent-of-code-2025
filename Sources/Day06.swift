struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  enum Operation: String {
    case add = "+"
    case multiply = "*"
  }

  // Splits input data into its component parts and convert from string.
  var entities: (operandList: [[Int]], operations: [Operation]) {
    let lines = data.split(separator: "\n").map { String($0) }
    
    let operandList = lines.dropLast().map { ln in ln.split(separator: " ").map { Int($0)! } }
    let operations = lines.last!.split(separator: " ").map { Operation(rawValue: String($0))! }

    return (operandList, operations)
  }

  var cephalopodEntities: (operands: [[String]], operations: [Operation]) {
    let lines = data.split(separator: "\n").map { String($0) }

    let operandStrings = lines.dropLast().map { ln in ln.split(separator: " ").map { String($0) } }
    let maxLen = operandStrings.joined().reduce(-1) { acc, elem in max(acc, elem.count) }

    var paddedOperands: [[String]] = []
    for ln in operandStrings {
      let paddedLine = ln.map { str in str.padding(toLength: maxLen, withPad: "0", startingAt: 0) }
      paddedOperands.append(paddedLine)
    }

    let operations = lines.last!.split(separator: " ").map { Operation(rawValue: String($0))! }

    return (paddedOperands, operations)
  }

  func groupToProblems(operandList: [[Int]], operations: [Operation]) -> [([Int], Operation)] {
    // given the problem array, where each column is to be operated on,
    // return a new array of tuples, containing a list of operands from the column and the corresponding operation
    var result: [([Int], Operation)] = []
    
    for j in 0..<operations.count {
      // loop through all columns
      var nums: [Int] = []
      for i in 0..<operandList.count {
        // loop through each row to get all items in column j
        nums.append(operandList[i][j])
      }

      result.append((nums, operations[j]))
    }

    return result
  }

  func solveProblem(operands: [Int], operation: Operation) -> Int {
    // reduces the operands according to the given operation
    switch operation {
      case .add: 
        return operands.reduce(0, +)
      case .multiply: 
        return operands.reduce(1, *)
    }
  }

  func part1() -> Any {
    groupToProblems(operandList: entities.operandList, operations: entities.operations).reduce(0) { acc, prob in 
      let (nums, op) = prob
      return acc + solveProblem(operands: nums, operation: op)
    }
  }

  func part2() -> Any {
    return ()
  }
}
