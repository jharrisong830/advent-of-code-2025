struct Day11: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct PathTuple: Hashable {
    let id: String
    let dac: Bool
    let fft: Bool

    init(_ id: String, _ dac: Bool, _ fft: Bool) {
      self.id = id
      self.dac = dac
      self.fft = fft
    }
  }

  // Splits input data into its component parts and convert from string.
  var entities: [[String]] {
    data.split(separator: "\n").map { $0.split(separator: ":").map { str in str.trimmingCharacters(in: .whitespacesAndNewlines) } }
  }

  func buildDict(_ networkMapping: [[String]]) -> [String: [String]] {
    // builds a mapping of servers to their outbound connections
    var dict: [String: [String]] = [:]
    for ln in networkMapping {
      let key = ln.first!
      let valList = ln.last!.split(separator: " ").map { String($0) }
      dict[key] = valList
    }

    return dict
  }

  func countPaths(network: [String: [String]]) -> Int {
    // counts the total number of paths that can be taken in the network from "you" to "out"
    var pathsMemo: [String: Int] = [:]

    func _countPaths(from k: String) -> Int {
      // recursive helper, starting from key k
      if let m = pathsMemo[k] { return m }
      if k == "out" { return 1 }

      let result = network[k]!.map { conn in _countPaths(from: conn) }.reduce(0, +)
      pathsMemo[k] = result
      return result
    }

    return _countPaths(from: "you")
  }

  func countDacFft(network: [String: [String]]) -> Int {
    // counts the total number of paths that contain "dac" and "fft" in the network from "svr" to "out"
    var pathsMemo: [PathTuple: Int] = [:]

    func _countDacFft(from k: String, _ dac: Bool, _ fft: Bool) -> Int {
      // recursive helper, starting from key k and marking whether either of the two specific servers have been reached 
      if let m = pathsMemo[PathTuple(k, dac, fft)] { return m } 
      if k == "out" { return dac && fft ? 1 : 0 }

      let result = network[k]!.map { conn in _countDacFft(from: conn, dac || k == "dac", fft || k == "fft") }.reduce(0, +)
      pathsMemo[PathTuple(k, dac, fft)] = result
      return result
    }

    return _countDacFft(from: "svr", false, false)
  }

  func part1() -> Any {
    countPaths(network: buildDict(entities))
  }

  func part2() -> Any {
    countDacFft(network: buildDict(entities))
  }
}
