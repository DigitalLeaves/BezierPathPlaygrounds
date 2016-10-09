//: # Bezier Paths 1. Basic shapes
//: This section shows the basics of UIBezierPath, how it can be used to describe custom shapes and generate images with them.
//: We will be using the CoreGraphics API fro drawing our shapes into images.

import UIKit

//: This extension on UIImage will allow us to generate a UIImage for a given UIBezierPath.
extension UIImage {
    class func shapeImageWithBezierPath(bezierPath: UIBezierPath, fillColor: UIColor?, strokeColor: UIColor?, strokeWidth: CGFloat = 0.0) -> UIImage! {
        //: Normalize bezier path. We will apply a transform to our bezier path to ensure that it's placed at the coordinate axis. Then we can get its size.
        bezierPath.apply(CGAffineTransform(translationX: -bezierPath.bounds.origin.x, y: -bezierPath.bounds.origin.y))
        let size = CGSize(width: bezierPath.bounds.size.width, height: bezierPath.bounds.size.height)
        
        //: Initialize an image context with our bezier path normalized shape and save current context
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        
        //: Set path
        context.addPath(bezierPath.cgPath)
        //: Set parameters and draw
        if strokeColor != nil {
            strokeColor!.setStroke()
            context.setLineWidth(strokeWidth)
        } else { UIColor.clear.setStroke() }
        fillColor?.setFill()
        context.drawPath(using: .fillStroke)

        //: Get the image from the current image context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //: Restore context and close everything
        context.restoreGState()
        UIGraphicsEndImageContext()
        //: Return image
        return image
    }
}

//: A rectangular shape
let rectShape = UIImage.shapeImageWithBezierPath(bezierPath: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 500, height: 300)), fillColor: UIColor.blue, strokeColor: nil, strokeWidth: 0.0)

//: A circle shape
let circleShape = UIImage.shapeImageWithBezierPath(bezierPath: UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100)), fillColor: UIColor.green, strokeColor: UIColor.darkGray, strokeWidth: 1.0)

//: A custom, more complex shape describing an arrow.
let arrowPath = UIBezierPath()
arrowPath.move(to: CGPoint(x: 50, y: 0))
arrowPath.addLine(to: CGPoint(x: 70, y: 25))
arrowPath.addLine(to: CGPoint(x: 60, y: 25))
arrowPath.addLine(to: CGPoint(x: 60, y: 75))
arrowPath.addLine(to: CGPoint(x: 40, y: 75))
arrowPath.addLine(to: CGPoint(x: 40, y: 25))
arrowPath.addLine(to: CGPoint(x: 30, y: 25))
arrowPath.addLine(to: CGPoint(x: 50, y: 0))
arrowPath.close()

let arrowShape = UIImage.shapeImageWithBezierPath(bezierPath: arrowPath, fillColor: UIColor.cyan, strokeColor: UIColor.blue, strokeWidth: 1.0)


