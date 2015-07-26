//: # Bezier Paths 2. Masking images.
//: Masking images is a really powerful way of improving your interface by adding custom shapes in your pictures. Nowaday many apps use this masking in user profiles, pictures, backgrounds, etc...

import UIKit

//: This extension will apply a custom UIBezierPath to an instance of UIImage, returning a new image with a clipped area specified by the path.
extension UIImage {
    func imageByApplyingClippingBezierPath(path: UIBezierPath) -> UIImage! {
        let frame = CGRectMake(0, 0, self.size.width, self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        path.addClip()
        self.drawInRect(frame)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        CGContextRestoreGState(context)
        UIGraphicsEndImageContext()
        return newImage
    }
}

//: Calculates the bezier path for a image without the bottom-right corner triangle
func bottomRightTriangledPathInRect(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    // initial point
    path.moveToPoint(CGPointMake(rect.origin.x, rect.origin.y))
    // make the polygon
    path.addLineToPoint(CGPointMake(rect.origin.x, CGRectGetMaxY(rect)))
    path.addLineToPoint(CGPointMake(CGRectGetMaxX(rect), 0.75 * CGRectGetMaxY(rect)))
    path.addLineToPoint(CGPointMake(CGRectGetMaxX(rect), rect.origin.y))
    path.addLineToPoint(CGPointMake(rect.origin.x, rect.origin.y))
    
    // close and return path
    path.closePath()
    return path
}

//: Original image from [Unsplash](www.unsplash.com)
let image = UIImage(named: "pic1.jpg")!

//: The second image has a clipping bottom-right triangle thanks to the path obtained from bottomRightTriangledPathInRect
let frame = CGRectMake(0, 0, image.size.width, image.size.height)
let image2 = image.imageByApplyingClippingBezierPath(bottomRightTriangledPathInRect(frame))

//: The third image has a typical circle mask like the ones you can find on modern social networks.
let minSide = min(image.size.width, image.size.height)
let clippedFrame = CGRectMake(0.5*(image.size.width-minSide), 0.5*(image.size.height-minSide), minSide, minSide)
let image3 = image.imageByApplyingClippingBezierPath(UIBezierPath(ovalInRect: clippedFrame))




