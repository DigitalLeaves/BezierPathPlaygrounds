//: # Bezier Paths 2. Masking images.
//: Masking images is a really powerful way of improving your interface by adding custom shapes in your pictures. Nowaday many apps use this masking in user profiles, pictures, backgrounds, etc...

import UIKit

//: This extension will apply a custom UIBezierPath to an instance of UIImage, returning a new image with a clipped area specified by the path.
extension UIImage {
    func imageByApplyingClippingBezierPath(_ path: UIBezierPath) -> UIImage! {
        let frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        self.draw(in: frame)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return newImage
    }
}

//: Calculates the bezier path for a image without the bottom-right corner triangle
func bottomRightTriangledPathInRect(_ rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    // initial point
    path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
    // make the polygon
    path.addLine(to: CGPoint(x: rect.origin.x, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: 0.75 * rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.origin.y))
    path.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
    
    // close and return path
    path.close()
    return path
}

//: Calculates the bezier path for a image without the bottom-right corner triangle
func topRightTriangledPathInRect(_ rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    // initial point
    path.move(to: CGPoint(x: rect.origin.x, y: 0.25 * rect.maxY))
    // make the polygon
    path.addLine(to: CGPoint(x: rect.origin.x, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.origin.y))
    path.addLine(to: CGPoint(x: rect.origin.x,  y: 0.25 * rect.maxY))
    
    // close and return path
    path.close()
    return path
}

//: Original image from [Unsplash](www.unsplash.com)
let image = UIImage(named: "pic1.jpg")!

//: The second image has a clipping bottom-right triangle thanks to the path obtained from bottomRightTriangledPathInRect
let frameBottom = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
let image2 = image.imageByApplyingClippingBezierPath(bottomRightTriangledPathInRect(frameBottom))

let frameTop = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
let image3 = image.imageByApplyingClippingBezierPath(topRightTriangledPathInRect(frameTop))

//: The third image has a typical circle mask like the ones you can find on modern social networks.
let minSide = min(image.size.width, image.size.height)
let clippedFrame = CGRect(x: 0.5*(image.size.width-minSide), y: 0.5*(image.size.height-minSide), width: minSide, height: minSide)
let image4 = image.imageByApplyingClippingBezierPath(UIBezierPath(ovalIn: clippedFrame))




