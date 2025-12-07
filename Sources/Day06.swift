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

  var cephalopodEntities: (operandList: [[Int]], operations: [Operation]) {
    let lines = data.split(separator: "\n").map { String($0) }

    let operands = lines.dropLast()
    let operations = lines.last!.split(separator: " ").map { Operation(rawValue: String($0))! }

    var operandList: [[Int]] = []
    var currOperands: [String] = []
    for i in 0..<operands.first!.count {
      let newNumStr = operands.map { 
        // get ith character of each line
        $0[$0.index($0.startIndex, offsetBy: i)]
      }.reduce("") { acc, char in 
        acc + (char == " " ? "" : String(char))
      }

      if newNumStr == "" {
        // we have all of the numbers for this problem
        let nums = currOperands.map { Int($0)! }
        operandList.append(nums)

        currOperands = [] // reset
      } else {
        currOperands.append(newNumStr)
      }
    }

    // add last problem when at end of line 
    if !currOperands.isEmpty { 
      let nums = currOperands.map { Int($0)! }
      operandList.append(nums)
    }

    return (operandList, operations)
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
    zip(cephalopodEntities.operandList, cephalopodEntities.operations).reduce(0) { acc, prob in 
      // zipping transposed matrix with operations gives tuples of problems
      let (nums, op) = prob
      return acc + solveProblem(operands: nums, operation: op)
    }
  }
}
