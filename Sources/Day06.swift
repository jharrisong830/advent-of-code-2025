struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  enum Operation: String {
    case add = "+"
    case multiply = "*"
  }

  // Splits input data into its component parts and convert from string.
  var entities: (operands: [[Int]], operations: [Operation]) {
    let lines = data.split(separator: "\n").map { String($0) }
    
    let operands = lines.dropLast().map { ln in ln.split(separator: " ").map { Int($0)! } }
    let operations = lines.last!.split(separator: " ").map { Operation(rawValue: String($0))! }

    return (operands, operations)
  }

  func solveProblemArray(operands: [[Int]], operations: [Operation]) -> Int {
    var overallResult = 0

    for j in 0..<operands.first!.count {
      var problemResult = operands[0][j]

      for i in 1..<operands.count {
        switch operations[j] {
          case .add: problemResult += operands[i][j]
          case .multiply: problemResult *= operands[i][j]
        }
      }

      overallResult += problemResult
    }

    return overallResult
  }

  func part1() -> Any {
    solveProblemArray(operands: entities.operands, operations: entities.operations)
  }

  func part2() -> Any {
    ()
  }
}
