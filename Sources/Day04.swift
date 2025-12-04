struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map { Array(String($0).trimmingCharacters(in: .whitespacesAndNewlines)) }
  }

  func getAdjacentPositions(_ i: Int, _ j: Int) -> [(Int, Int)] {
    return [
      (i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1), (i - 1, j - 1), (i + 1, j - 1), (i - 1, j + 1), (i + 1, j + 1)
    ]
  }

  func getAccessible(grid: [[Character]]) -> [(Int, Int)] {
    // returns a list of coords which are accessible by forklifts (more than 4 adjacent spots)
    var accessible: [(Int, Int)] = []

    for i in 0..<grid.count {
      for j in 0..<grid[i].count {
        if grid[i][j] != "@" { continue } // empty, not paper
        let adj = getAdjacentPositions(i, j)
        let openSpots = adj.filter { (x, y) in // adj spot free if out of bounds or is "."
          x < 0 || x >= grid.count || y < 0 || y >= grid[i].count || grid[x][y] == "."
        }
        if openSpots.count > 4 { accessible.append((i, j)) }
      }
    }

    return accessible
  }

  func part1() -> Any {
    getAccessible(grid: entities).count
  }

  func part2() -> Any {
    var grid = entities
    var accessible = getAccessible(grid: grid)
    var removed = 0

    repeat { 
      removed += accessible.count
      for (i, j) in accessible {
        grid[i][j] = "."
      }

      accessible = getAccessible(grid: grid)
    } while accessible.count > 0

    return removed
  }
}
