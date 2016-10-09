//: # Bezier Paths 3. Paths in views.
//: One of the most powerful uses for UIBezierPath is being able to modify the looks and structure of your views. This can be as simple as drawing an arrow in a popup dialog view or designing a completely custom user experience.

import UIKit

//: Some auxiliary functions to help us translate from degrees to radians and vice-versa.
func degreesToRadians (_ value:CGFloat) -> CGFloat {
    return value * CGFloat(M_PI) / 180.0
}

func radiansToDegrees (_ value:CGFloat) -> CGFloat {
    return value * 180.0 / CGFloat(M_PI)
}

//: This method will create a UIBezierPath with a "PopUp dialog" shape. This bezier path can then be used to clip any UIView to generate a dialog view.
func dialogBezierPathWithFrame(_ frame: CGRect, arrowOrientation orientation: UIImageOrientation, arrowLength: CGFloat = 20.0) -> UIBezierPath {
    // Translate frame to neutral coordinate system & transpose it to fit the orientation.
    var transposedFrame = CGRect.zero
    switch orientation {
    case .up, .down, .upMirrored, .downMirrored:
        transposedFrame = CGRect(x: 0, y: 0, width: frame.size.width - frame.origin.x, height: frame.size.height - frame.origin.y)
    case .left, .right, .leftMirrored, .rightMirrored:
        transposedFrame = CGRect(x: 0, y: 0,  width: frame.size.height - frame.origin.y, height: frame.size.width - frame.origin.x)
    }
    
    // We need 7 points for our Bezier path
    let midX = transposedFrame.midX
    let point1 = CGPoint(x: transposedFrame.minX, y: transposedFrame.minY + arrowLength)
    let point2 = CGPoint(x: midX - (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point3 = CGPoint(x: midX, y: transposedFrame.minY)
    let point4 = CGPoint(x: midX + (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point5 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.minY + arrowLength)
    let point6 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.maxY)
    let point7 = CGPoint(x: transposedFrame.minX, y: transposedFrame.maxY)
    
    // Build our Bezier path
    let path = UIBezierPath()
    path.move(to: point1)
    path.addLine(to: point2)
    path.addLine(to: point3)
    path.addLine(to: point4)
    path.addLine(to: point5)
    path.addLine(to: point6)
    path.addLine(to: point7)
    path.close()
    
    // Rotate our path to fit orientation
    switch orientation {
    case .up, .upMirrored:
        break // do nothing
    case .down, .downMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(180.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.width, y: transposedFrame.size.height))
    case .left, .leftMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(-90.0)))
        path.apply(CGAffineTransform(translationX: 0, y: transposedFrame.size.width))
    case .right, .rightMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(90.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.height, y: 0))
    }
    
    return path
}


//: Let's create a basic, blue view.
let view = UIView(frame: CGRect(x: 100, y: 200, width: 200, height: 400))
view.backgroundColor = UIColor.blue
//: Now we generate our popup dialog shape.
let arrowDialogPath = dialogBezierPathWithFrame(view.frame, arrowOrientation: .down)

//: Next, we'll create a CAShapeLayer that will mask our view.
let shapeLayer = CAShapeLayer()
shapeLayer.path = arrowDialogPath.cgPath
shapeLayer.fillColor = UIColor.white.cgColor
shapeLayer.fillRule = kCAFillRuleEvenOdd
view.layer.mask = shapeLayer
view

//: To test that everything looks nice, we add our popup view as a subview of a bigger, ugly gray view.
let bigView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
bigView.backgroundColor = UIColor.lightGray
bigView.addSubview(view)

