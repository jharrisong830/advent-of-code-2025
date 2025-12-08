struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point: Equatable, Hashable {
    var i: Int
    var j: Int

    init(_ i: Int, _ j: Int) {
      self.i = i
      self.j = j
    }
  }

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map { Array(String($0)) }
  }

  func findNumberSplits(graph g: [[Character]]) -> Int {
    // returns the number of times a beam is split
    var visitedPoints: [Point] = [] // memoize to prevent overlapping calls

    func _findNumberSplits(graph g: [[Character]], startingAt: Point) -> Int {
      // helper func
      var p = startingAt

      while p.i < g.count && g[p.i][p.j] != "^" {
        if visitedPoints.contains(p) { return 0 } // stop processing if we encounter a point that a beam has visited
        visitedPoints.append(p)
        // move down one level until we reach a split
        p.i += 1 
      }

      if p.i == g.count { return 0 } // at the bottom of the graph
      // otherwise, split into two new paths (left and right)

      let leftPoint = Point(p.i, p.j - 1)
      let left = _findNumberSplits(graph: g, startingAt: leftPoint)

      let rightPoint = Point(p.i, p.j + 1)
      let right = _findNumberSplits(graph: g, startingAt: rightPoint)

      return 1 + left + right
    }

    let result = _findNumberSplits(graph: g, startingAt: Point(0, entities[0].firstIndex(of: "S")!))

    return result
  }

  func findTimelines(graph g: [[Character]]) -> Int {
    // returns the number of timelines created by beam splits
    var splitterTimelines: Dictionary<Point, Int> = [:] // memoize to prevent overlapping calls

    func _findTimelines(graph g: [[Character]], startingAt: Point) -> Int {
      // helper func
      var p = startingAt

      while p.i < g.count && g[p.i][p.j] != "^" {
        // move down one level until we reach a split
        p.i += 1 
      }

      if let memoized = splitterTimelines[p] { return memoized } // stop processing if we encounter a splitter that has been calculated

      if p.i == g.count { return 1 } // at the bottom of the graph, just this timeline exists
      // otherwise, split into two new paths (left and right), marking the split we encountered

      let leftPoint = Point(p.i, p.j - 1)
      let left = _findTimelines(graph: g, startingAt: leftPoint)

      let rightPoint = Point(p.i, p.j + 1)
      let right = _findTimelines(graph: g, startingAt: rightPoint)

      let currResult = left + right // get timelines from the left and right subtrees
      splitterTimelines[p] = currResult

      return currResult
    }

    let result = _findTimelines(graph: g, startingAt: Point(0, entities[0].firstIndex(of: "S")!))

    return result
  }

  func part1() -> Any {
    findNumberSplits(graph: entities)
  }

  func part2() -> Any {
    findTimelines(graph: entities)
  }
}
