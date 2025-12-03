struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func countClicks(curr: Int, instr: String) -> (Int, Int) {
    // Given a current position on the dial and an instruction, returns a tuple of the new position and the number of clicks
    let direction = switch instr.first {
      case "L": -1
      case "R": 1
      default: 0 // shouln't reach
    }

    let val = Int(instr.dropFirst())!

    var new = curr
    var clicks = 0

    for _ in 0..<val { 
      new += direction
      if new == 0 { // clicked past 0
        clicks += 1
      } else if new == -1 { // roll back to 99
        new = 99
      } else if new == 100 { // equivalent to 0
        clicks += 1
        new = 0
      }
    }

    return (new, clicks)
  }

  func part1() -> Any {
    var positions = [50] // start at 50

    for instr in entities {
      if let curr = positions.last {
        let (newPos, _) = countClicks(curr: curr, instr: instr)
        positions.append(newPos)
      }
    }

    return positions.reduce(0, { acc, x in acc + (x == 0 ? 1 : 0) })
  }

  func part2() -> Any {
    var positions = [50] // start at 50
    var totalClicks = 0 // counting total clicks

    for instr in entities {
      if let curr = positions.last {
        let (newPos, clicks) = countClicks(curr: curr, instr: instr)
        positions.append(newPos)
        totalClicks += clicks
      }
    }

    return totalClicks
  }
}
