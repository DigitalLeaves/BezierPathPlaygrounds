//: # Bezier Paths 1. Basic shapes
//: This section shows the basics of UIBezierPath, how it can be used to describe custom shapes and generate images with them.
//: We will be using the CoreGraphics API fro drawing our shapes into images.

import UIKit

//: This extension on UIImage will allow us to generate a UIImage for a given UIBezierPath.
extension UIImage {
    class func shapeImageWithBezierPath(bezierPath: UIBezierPath, fillColor: UIColor?, strokeColor: UIColor?, strokeWidth: CGFloat = 0.0) -> UIImage! {
        //: Normalize bezier path. We will apply a transform to our bezier path to ensure that it's placed at the coordinate axis. Then we can get its size.
        bezierPath.applyTransform(CGAffineTransformMakeTranslation(-bezierPath.bounds.origin.x, -bezierPath.bounds.origin.y))
        let size = CGSizeMake(bezierPath.bounds.size.width, bezierPath.bounds.size.height)
        
        //: Initialize an image context with our bezier path normalized shape and save current context
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        //: Set path
        CGContextAddPath(context, bezierPath.CGPath)
        //: Set parameters and draw
        if strokeColor != nil {
            strokeColor!.setStroke()
            CGContextSetLineWidth(context, strokeWidth)
        } else { UIColor.clearColor().setStroke() }
        fillColor?.setFill()
        CGContextDrawPath(context, .FillStroke)

        //: Get the image from the current image context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //: Restore context and close everything
        CGContextRestoreGState(context)
        UIGraphicsEndImageContext()
        //: Return image
        return image
    }
}

//: A rectangular shape
let rectShape = UIImage.shapeImageWithBezierPath(UIBezierPath(rect: CGRectMake(0, 0, 500, 300)), fillColor: UIColor.blueColor(), strokeColor: nil, strokeWidth: 0.0)

//: A circle shape
let circleShape = UIImage.shapeImageWithBezierPath(UIBezierPath(ovalInRect: CGRectMake(0, 0, 100, 100)), fillColor: UIColor.greenColor(), strokeColor: UIColor.darkGrayColor(), strokeWidth: 1.0)

//: A custom, more complex shape describing an arrow.
let arrowPath = UIBezierPath()
arrowPath.moveToPoint(CGPointMake(50, 0))
arrowPath.addLineToPoint(CGPointMake(70, 25))
arrowPath.addLineToPoint(CGPointMake(60, 25))
arrowPath.addLineToPoint(CGPointMake(60, 75))
arrowPath.addLineToPoint(CGPointMake(40, 75))
arrowPath.addLineToPoint(CGPointMake(40, 25))
arrowPath.addLineToPoint(CGPointMake(30, 25))
arrowPath.addLineToPoint(CGPointMake(50, 0))
arrowPath.closePath()

let arrowShape = UIImage.shapeImageWithBezierPath(arrowPath, fillColor: UIColor.cyanColor(), strokeColor: UIColor.blueColor(), strokeWidth: 1.0)


