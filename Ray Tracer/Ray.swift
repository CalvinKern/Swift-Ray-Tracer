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
        findFirstIntersection(fromEye, withRay:direction)
    }
    
    public func findFirstIntersection(withPoint:Vector3, withRay:Vector3) {
        
        var shapes:Array<Shape> = Scene.sharedInstance.getShapes()
        
        if (shapes.count == 0) {
            return
        }
        var firstShape:Shape?
        var firstIntersection:Vector3?
        var firstIntersectionDistance:Float = 0;
        
        for shape in shapes {
            var intersectPosition:Vector3? = shape.getIntersection(withRay)
            if (intersectPosition == nil) {
                continue
            }

            var intersectionDistance:Float = getSquaredDistance(withPoint, toPoint: intersectPosition!)
            if (firstShape == nil ||
                (intersectionDistance < firstIntersectionDistance)) {
                    firstShape = shape
                    firstIntersection = intersectPosition
                    firstIntersectionDistance = intersectionDistance
                    color = shape.material.color
            }
        }
        
        //TODO: lighting
    }
    
    public func getColor() -> Vector3 {
        return color
    }
    
    private func getSquaredDistance(point:Vector3, toPoint:Vector3) -> Float {
        var subVector:Vector3 = toPoint - point
        return ( subVector.x * subVector.x + subVector.y * subVector.y + subVector.z * subVector.z)
    }
}