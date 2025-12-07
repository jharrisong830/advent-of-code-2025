struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  enum Operation: String {
    case add = "+"
    case multiply = "*"
  }

  func transpose<T>(matrix a: [[T]]) throws -> [[T]] {
    if !a.allSatisfy({ $0.count == a.first!.count }) {
      fatalError("matrix not rectangular")
    }

    let rows = a.count
    let cols = a.first!.count

    var new: [[T]] = []

    for i in 0..<cols {
      var newRow: [T] = []
      for j in 0..<rows {
        newRow.append(a[j][i]) // new[i][j] = old[j][i]
      }
      new.append(newRow)
    }

    return new
  }

  // Splits input data into its component parts and convert from string.
  var entities: (operandList: [[Int]], operations: [Operation]) {
    let lines = data.split(separator: "\n").map { String($0) }
    
    let operandList = lines.dropLast().map { ln in ln.split(separator: " ").map { Int($0)! } }
    let transposedOperandList = try! transpose(matrix: operandList) // transpose, such that each sublist is a grouping for a problem

    let operations = lines.last!.split(separator: " ").map { Operation(rawValue: String($0))! }

    return (transposedOperandList, operations)
  }

  var cephalopodEntities: (operandList: [[String]], operations: [Operation]) {
    let lines = data.split(separator: "\n").map { String($0) }

    let operandStrings = lines.dropLast().map { ln in ln.split(separator: " ").map { String($0) } }
    let maxLen = operandStrings.joined().reduce(-1) { acc, elem in max(acc, elem.count) }

    var paddedOperands: [[String]] = []
    for ln in operandStrings {
      let paddedLine = ln.map { str in str.padding(toLength: maxLen, withPad: "0", startingAt: 0) }
      paddedOperands.append(paddedLine)
    }

    let operations = lines.last!.split(separator: " ").map { Operation(rawValue: String($0))! }

    for j in 0..<operations.count {
      // loop through all columns
      var nums: [String] = [] // collect all strings for this column
      for i in 0..<operandStrings.count {
        // loop through each row to get all items in column j
        nums.append(operandStrings[i][j])
      }

      var cephalopodNums: [String] = []
      for l in 0..<maxLen {
        var reconstructed = ""
        for k in 0..<nums.count {
          let currInd = nums[k].index(nums[k].startIndex, offsetBy: l)
          reconstructed += String(nums[k][currInd])
        }
        cephalopodNums.append(reconstructed)
      }
      print(cephalopodNums)
    }

    return (paddedOperands, operations)
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
    zip(entities.operandList, entities.operations).reduce(0) { acc, prob in 
      // zipping transposed matrix with operations gives tuples of problems
      let (nums, op) = prob
      return acc + solveProblem(operands: nums, operation: op)
    }
  }

  func part2() -> Any {
    cephalopodEntities
    return ()
  }
}
