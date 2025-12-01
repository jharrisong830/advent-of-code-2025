import Foundation

func getInputFromFile(path: String) -> [String] {
    let fm = FileManager.default
    if let fData = fm.contents(atPath: path) {
        guard let fullString = String(data: fData, encoding: .utf8) else {
            return []
        }
        return fullString.split(separator: "\n").map { String($0) }
    }
    return []
}



func countClicks(curr: Int, instr: String) -> (Int, Int) {
    let direction = switch instr.first! {
        case "L": -1
        case "R": 1
        default: 0
    }

    let val = Int(instr.dropFirst())!
    
    var new = curr
    var clicks = 0

    for _ in 0..<val {
        new += direction
        if new == 0 {
            clicks += 1
        } else if new == -1 {
            new = 99
        } else if new == 100 {
            clicks += 1
            new = 0
        }
    }

    return (new, clicks)
}



func main() {
    let input = getInputFromFile(path: "./input.txt")

    var positions = [50]
    var clickCounts = 0

    for instr in input {
        if let curr = positions.last {
            let (newPos, clicks) = countClicks(curr: curr, instr: instr)
            positions.append(newPos)
            clickCounts += clicks
        }
    }

    let part1 = positions.reduce(0, { $0 + ($1 == 0 ? 1 : 0) })

    print("Part 1 Answer: \(part1)")
    print("Part 2 Answer: \(clickCounts)")
}

main()
