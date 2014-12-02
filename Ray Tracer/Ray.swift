//
//  Ray.swift
//  Ray_Tracer
// Ray direction: (destination - origin)
//
//  Created by Calvin Kern on 11/27/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

public class Ray {

    var color:Vector3 = Vector3(0,0,255)
    
    init(fromEye:Vector3, direction:Vector3) {
        color = findFirstIntersection(fromEye, withRay:direction, withShadow:true)
    }
    
    public func findFirstIntersection(withPoint:Vector3, withRay:Vector3, withShadow:Bool) -> Vector3 {
        
        var shapes:Array<Shape> = Scene.sharedInstance.getShapes()
        
        if (shapes.count == 0) {
            return Vector3(0,0,255)
        }
        var firstShape:Shape?
        var firstIntersection:Vector3?
        var firstIntersectionDistance:Float = 0;
        
        for shape in shapes {
            let intersect = shape.getIntersection(withRay, fromPoint: withPoint)
            if (intersect.position == nil) {
                continue
            }

            if (firstShape == nil ||
                (intersect.t < firstIntersectionDistance && intersect.t > 0)) {
                    firstShape = shape
                    firstIntersection = intersect.position
                    firstIntersectionDistance = intersect.t
            }
        }
        
        if (withShadow && firstShape != nil) {
            let lightDirection = (Scene.sharedInstance.lightPosition - firstIntersection!).normalize()
//            let lightDotNorm = Vector3(lightDirection.x, lightDirection.y, lightDirection.z).dot(firstShape!.normal(firstIntersection!)!)
            let lightDotNorm = firstShape!.normal(firstIntersection!)!.dot(lightDirection)
            let lightColor = findLightVectorIntersection(firstIntersection!, inShape: firstShape!, withLightDirection: lightDirection)
            let shapeMaterialColor = firstShape!.material.color
            
            let red = (shapeMaterialColor.x) * lightColor.x
            let green = (shapeMaterialColor.y) * lightColor.y
            let blue = (shapeMaterialColor.z) * lightColor.z
            
//            var shapeColor = firstShape!.material.color * Scene.sharedInstance.lightColor * lightDotNorm
            var shapeColor = Vector3(red / 255.0, green / 255.0, blue / 255.0) * lightDotNorm
            
//            shapeColor = Vector3(abs(shapeColor.x), abs(shapeColor.y), abs(shapeColor.z))

            if (shapeMaterialColor.y == 255.0) {
//                (Scene.sharedInstance.printlnVector(lightDirection))
//                shapeColor = Vector3(255,255,255)
            }

            shapeColor = Vector3(
                shapeColor.x < 0 ? 0 : shapeColor.x,
                shapeColor.y < 0 ? 0 : shapeColor.y,
                shapeColor.z < 0 ? 0 : shapeColor.z)

            shapeColor = Vector3(
                shapeColor.x > 255 ? 255 : shapeColor.x,
                shapeColor.y > 255 ? 255 : shapeColor.y,
                shapeColor.z > 255 ? 255 : shapeColor.z)
            

            return shapeColor
        }
        
        return Vector3(81,170,232) // Return sky if no shape intersected
    }
    
    public func findLightVectorIntersection(withPoint:Vector3, inShape:Shape, withLightDirection:Vector3) -> Vector3 {
        var shapes = Scene.sharedInstance.getShapes()
        for shape in shapes {
            if (shape === inShape) {
                continue
            }
            else {
                let intersect = shape.getIntersection(withLightDirection, fromPoint: withPoint)
                if (intersect.position != nil) {
                    return Vector3(100,100,100)
                } else {
                    continue
                }
            }
        }
        return Scene.sharedInstance.lightColor
    }
    
    public func getColor() -> Vector3 {
        return color
    }
    
    private func getSquaredDistance(point:Vector3, toPoint:Vector3) -> Float {
        var subVector:Vector3 = toPoint - point
        return ( subVector.x * subVector.x + subVector.y * subVector.y + subVector.z * subVector.z)
    }
}