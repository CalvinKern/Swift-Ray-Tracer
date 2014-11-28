//
//  Ray.swift
//  Ray_Tracer
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
            return Vector3(0,0,256)
        }
        var firstShape:Shape?
        var firstIntersection:Vector3?
        var firstIntersectionDistance:Float = 0;
        
        for shape in shapes {
            var intersectPosition:Vector3? = shape.getIntersection(withRay, fromPoint: withPoint)
            if (intersectPosition == nil) {
                continue
            }

            var intersectionDistance:Float = getSquaredDistance(withPoint, toPoint: intersectPosition!)
            if (firstShape == nil ||
                (intersectionDistance < firstIntersectionDistance)) {
                    firstShape = shape
                    firstIntersection = intersectPosition
                    firstIntersectionDistance = intersectionDistance
            }
        }
        
        //TODO: lighting
        if (withShadow && firstShape != nil) {
            let lightDirection = (Scene.sharedInstance.lightPosition - withPoint).normalize()
//            let lightColor = findLightVectorIntersection(firstIntersection!, withLightDirection: lightDirection)
            let lightDotNorm = lightDirection.dot(firstShape!.normal(firstIntersection!)!)

            let shapeMaterialColor = firstShape!.material.color
            let lightColor = Scene.sharedInstance.lightColor
            
            let red = shapeMaterialColor.x * lightColor.x / 255
            let green = shapeMaterialColor.y * lightColor.y / 255
            let blue = shapeMaterialColor.z * lightColor.z / 255
            
//            var shapeColor = firstShape!.material.color * Scene.sharedInstance.lightColor * lightDotNorm
            var shapeColor = Vector3(red, green, blue) * lightDotNorm
            
            shapeColor = Vector3(
                shapeColor.x < 0 ? 0 : shapeColor.x,
                shapeColor.y < 0 ? 0 : shapeColor.y,
                shapeColor.z < 0 ? 0 : shapeColor.z)
            
            return shapeColor
        }
        
        return Vector3(0,0,256)
    }
    
    public func findLightVectorIntersection(withPoint:Vector3, withLightDirection:Vector3) -> Vector3 {
        return findFirstIntersection(withPoint, withRay: withLightDirection, withShadow: false)
    }
    
    public func getColor() -> Vector3 {
        return color
    }
    
    private func getSquaredDistance(point:Vector3, toPoint:Vector3) -> Float {
        var subVector:Vector3 = toPoint - point
        return ( subVector.x * subVector.x + subVector.y * subVector.y + subVector.z * subVector.z)
    }
}