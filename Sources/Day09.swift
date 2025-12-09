struct Day09: AdventDay {
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

  struct Rectangle: Equatable {
    let cornerA: Point
    let cornerB: Point

    init(_ cornerA: Point, _ cornerB: Point) {
        self.cornerA = cornerA
        self.cornerB = cornerB
    }

    func getALength() -> Int {
      abs(self.cornerA.i - self.cornerB.i) + 1
    }

    func getBLength() -> Int {
      abs(self.cornerA.j - self.cornerB.j) + 1
    }

    func getArea() -> Int {
      self.getALength() * self.getBLength()
    }
  }

  // Splits input data into its component parts and convert from string.
  var entities: [Point] {
    data.split(separator: "\n").map { $0.split(separator: ",") }.map { pair in Point(Int(pair.first!)!, Int(pair.last!)!) }
  }

  func getAllRectangles(points: [Point]) -> [Rectangle] {
    // returns rectangles from all possible combinations of points
    points.combinations(ofCount: 2).map { pair in Rectangle(pair.first!, pair.last!) }
  }

  func part1() -> Any {
    getAllRectangles(points: entities).map { $0.getArea() }.max()!
  }

  func part2() -> Any {
    ()
  }
}
