//: # Bezier Paths 3. Paths in views.
//: One of the most powerful uses for UIBezierPath is being able to modify the looks and structure of your views. This can be as simple as drawing an arrow in a popup dialog view or designing a completely custom user experience.

import UIKit

//: Some auxiliary functions to help us translate from degrees to radians and vice-versa.
func degreesToRadians (value:CGFloat) -> CGFloat {
    return value * CGFloat(M_PI) / 180.0
}

func radiansToDegrees (value:CGFloat) -> CGFloat {
    return value * 180.0 / CGFloat(M_PI)
}

//: This method will create a UIBezierPath with a "PopUp dialog" shape. This bezier path can then be used to clip any UIView to generate a dialog view.
func dialogBezierPathWithFrame(frame: CGRect, arrowOrientation orientation: UIImageOrientation, arrowLength: CGFloat = 20.0) -> UIBezierPath {
    // Translate frame to neutral coordinate system & transpose it to fit the orientation.
    var transposedFrame = CGRectZero
    switch orientation {
    case .Up, .Down, .UpMirrored, .DownMirrored:
        transposedFrame = CGRectMake(0, 0, frame.size.width - frame.origin.x, frame.size.height - frame.origin.y)
    case .Left, .Right, .LeftMirrored, .RightMirrored:
        transposedFrame = CGRectMake(0, 0,  frame.size.height - frame.origin.y, frame.size.width - frame.origin.x)
    }
    
    // We need 7 points for our Bezier path
    let midX = CGRectGetMidX(transposedFrame)
    let point1 = CGPoint(x: CGRectGetMinX(transposedFrame), y: CGRectGetMinY(transposedFrame) + arrowLength)
    let point2 = CGPoint(x: midX - (arrowLength / 2), y: CGRectGetMinY(transposedFrame) + arrowLength)
    let point3 = CGPoint(x: midX, y: CGRectGetMinY(transposedFrame))
    let point4 = CGPoint(x: midX + (arrowLength / 2), y: CGRectGetMinY(transposedFrame) + arrowLength)
    let point5 = CGPoint(x: CGRectGetMaxX(transposedFrame), y: CGRectGetMinY(transposedFrame) + arrowLength)
    let point6 = CGPoint(x: CGRectGetMaxX(transposedFrame), y: CGRectGetMaxY(transposedFrame))
    let point7 = CGPoint(x: CGRectGetMinX(transposedFrame), y: CGRectGetMaxY(transposedFrame))
    
    // Build our Bezier path
    let path = UIBezierPath()
    path.moveToPoint(point1)
    path.addLineToPoint(point2)
    path.addLineToPoint(point3)
    path.addLineToPoint(point4)
    path.addLineToPoint(point5)
    path.addLineToPoint(point6)
    path.addLineToPoint(point7)
    path.closePath()
    
    // Rotate our path to fit orientation
    switch orientation {
    case .Up, .UpMirrored:
        break // do nothing
    case .Down, .DownMirrored:
        path.applyTransform(CGAffineTransformMakeRotation(degreesToRadians(180.0)))
        path.applyTransform(CGAffineTransformMakeTranslation(transposedFrame.size.width, transposedFrame.size.height))
    case .Left, .LeftMirrored:
        path.applyTransform(CGAffineTransformMakeRotation(degreesToRadians(-90.0)))
        path.applyTransform(CGAffineTransformMakeTranslation(0, transposedFrame.size.width))
    case .Right, .RightMirrored:
        path.applyTransform(CGAffineTransformMakeRotation(degreesToRadians(90.0)))
        path.applyTransform(CGAffineTransformMakeTranslation(transposedFrame.size.height, 0))
    }
    
    return path
}


//: Let's create a basic, blue view.
let view = UIView(frame: CGRectMake(100, 200, 200, 400))
view.backgroundColor = UIColor.blueColor()
//: Now we generate our popup dialog shape.
let arrowDialogPath = dialogBezierPathWithFrame(view.frame, arrowOrientation: .Down)

//: Next, we'll create a CAShapeLayer that will mask our view.
let shapeLayer = CAShapeLayer()
shapeLayer.path = arrowDialogPath.CGPath
shapeLayer.fillColor = UIColor.whiteColor().CGColor
shapeLayer.fillRule = kCAFillRuleEvenOdd
view.layer.mask = shapeLayer
view

//: To test that everything looks nice, we add our popup view as a subview of a bigger, ugly gray view.
let bigView = UIView(frame: CGRectMake(0, 0, 1000, 1000))
bigView.backgroundColor = UIColor.lightGrayColor()
bigView.addSubview(view)

