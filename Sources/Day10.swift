struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Machine {
    let indicator: [Bool]
    let wirings: [[Int]]
    let joltages: [Int]

    init(_ indicator: [Bool], _ wirings: [[Int]], _ joltages: [Int]) {
      self.indicator = indicator
      self.wirings = wirings
      self.joltages = joltages
    }

    func minPressesToSolve() -> Int {
      var state = Array(repeatElement(false, count: self.indicator.count))
      var presses = 0

      while state != indicator {
        presses += 1
        for comb in self.wirings.combinations(ofCount: presses) {
          // start from beginning state, and try combinations until we reach the desired state
          state = Array(repeatElement(false, count: self.indicator.count)) 
          for button in comb {
            // press the buttons in this combination
            state = Machine.pressButton(state: state, wiring: button)
          }
          if state == self.indicator { break } // break if we reach desired state, `presses` = min number of presses 
        }
      }

      return presses
    }

    func minPressesForJoltage() -> Int {
      var state = Array(repeatElement(0, count: self.joltages.count))
      var presses = 0

      print(self)

      while state != self.joltages {
        presses += 1
        print(presses)
        for comb in self.wirings.combinations(ofCount: presses) {
          // start from beginning state, and try combinations until we reach the desired state
          state = Array(repeatElement(0, count: self.indicator.count)) 
          for button in comb {
            state = Machine.adjustJoltage(state: state, wiring: button)
          }
          if state == self.joltages { break }
        }
      }

      return presses
    }

    static func pressButton(state s: [Bool], wiring: [Int]) -> [Bool] {
      var newState = s
      
      for x in wiring {
        newState[x] = !newState[x]
      }

      return newState
    }

    static func adjustJoltage(state s: [Int], wiring: [Int]) -> [Int] {
      var newState = s

      for x in wiring {
        newState[x] += 1
      }

      return newState
    }
  }

  // Splits input data into its component parts and convert from string.
  var entities: [Machine] {
    let machineSpec = /\[([\.#]+)\] (\(\d(?:,\d)*\)(?: \(\d(?:,\d)*\))*) \{(\d+(?:,\d+)*)\}/
    /*
      \[([\.#]+)\]                              -> captures desired state
      (\(\d(?:,\d)*\)(?: \(\d(?:,\d)*\))*)      -> captures schematics (needs further processing)
      \{(\d+(?:,\d+)*)\}                        -> captures joltages
    */

    return data.split(separator: "\n").map { ln in 
      let match = ln.wholeMatch(of: machineSpec)!
      
      let indicator = match.output.1.map { char in char == "#" }
      let schematics = match.output.2 // needs to be processed
      let joltages = match.output.3.split(separator: ",").map { num in Int(num)! }

      let wirings = schematics.split(separator: " ").map { schem in 
        schem.trimmingCharacters(in: .init(charactersIn: "()")).split(separator: ",").map { num in Int(num)! }
      }

      return Machine(indicator, wirings, joltages)
    }
  }

  func part1() -> Any {
    entities.map { m in m.minPressesToSolve() }.reduce(0, +)
  }

  func part2() -> Any {
    0
    // entities.map { m in m.minPressesForJoltage() }.reduce(0, +)
  }
}
