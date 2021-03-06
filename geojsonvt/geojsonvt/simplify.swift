import Foundation

class Simplify {

    class func simplify(#points: ProjectedGeometryContainer, tolerance: Double) {

        let sqTolerance = tolerance * tolerance
        let len = points.members.count
        var first = 0
        var last = len - 1
        var stack = [Int]()
        var maxSqDist: Double = 0
        var sqDist: Double = 0
        var index: Int = 0

        (points.members[first] as! ProjectedPoint).z = 1
        (points.members[last]  as! ProjectedPoint).z = 1

        while (last > 0) {

            maxSqDist = 0

            for i in (first + 1)..<last {
                sqDist = Simplify.getSqSegDist(points.members[i] as! ProjectedPoint,
                    a: points.members[first] as! ProjectedPoint,
                    b: points.members[last]  as! ProjectedPoint)

                if (sqDist > maxSqDist) {
                    index = i
                    maxSqDist = sqDist
                }
            }

            if (maxSqDist > sqTolerance) {
                (points.members[index] as! ProjectedPoint).z = maxSqDist
                stack.append(first)
                stack.append(index)
                stack.append(index)
                stack.append(last)
            }

            if (stack.count > 0) {
                last = stack.removeLast()
            } else {
                last = 0
            }

            if (stack.count > 0) {
                first = stack.removeLast()
            } else {
                first = 0
            }
        }
    }

    class func getSqSegDist(p: ProjectedPoint, a: ProjectedPoint, b: ProjectedPoint) -> Double {

        var x = a.x
        var y = a.y
        var dx = b.x - a.x
        var dy = b.y - a.y

        if (dx != 0 || dy != 0) {

            let t = ((p.x - a.x) * dx + (p.y - a.y) * dy) / (dx * dx + dy * dy)

            if (t > 1) {
                x = b.x
                y = b.y
            } else if (t > 0) {
                x += dx * t
                y += dy * t
            }
        }
        
        dx = p.x - x
        dy = p.y - y
        
        return dx * dx + dy * dy
    }
}
