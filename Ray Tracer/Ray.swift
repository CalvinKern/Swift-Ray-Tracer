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
        color = findFirstIntersection(fromEye, withRay:direction, withShadow:true, withBounceCount:2)
    }
    
    public func findFirstIntersection(withPoint:Vector3, withRay:Vector3, withShadow:Bool, withBounceCount:Int = 1) -> Vector3 {
        
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
        
        if (firstShape != nil) {
            if (firstShape!.isReflective) {// && withBounceCount != 0) {
                let ray = getRayReflectionVectorWith(shape: firstShape!, withRay: withRay, atIntersection: firstIntersection!, withBounceCount: withBounceCount);
                return findFirstIntersection(ray.intersection, withRay: ray.dir, withShadow: true, withBounceCount: withBounceCount - 1)
            } else if (withShadow) {
                
                let lightDirection = (Scene.sharedInstance.lightPosition - firstIntersection!).normalize()
                let lightDotNorm = firstShape!.normal(firstIntersection!)!.dot(lightDirection)
                
                let reflect = getRayReflectionVectorWith(shape: firstShape!, withRay: lightDirection * -1, atIntersection: firstIntersection!, withBounceCount: withBounceCount - 1)
                let reflectDotView = pow(reflect.dir.dot(withRay * -1), 5)
                
                let lightColor = findLightVectorIntersection(firstIntersection!, inShape: firstShape!, withLightDirection: lightDirection)
                let shapeMaterialColor = firstShape!.material.getMaterialColor(firstIntersection!)
                
                let red = (shapeMaterialColor.x) * lightColor.x
                let green = (shapeMaterialColor.y) * lightColor.y
                let blue = (shapeMaterialColor.z) * lightColor.z
                
                let ambient = Vector3(red / 255.0, green / 255.0, blue / 255.0)
                let diffuse = ambient * lightDotNorm
                let specular = ambient * reflectDotView

                var shapeColor = (ambient * 0.1) + diffuse + specular
                
                shapeColor = Vector3(
                    shapeColor.x < 0 ? 0 : shapeColor.x,
                    shapeColor.y < 0 ? 0 : shapeColor.y,
                    shapeColor.z < 0 ? 0 : shapeColor.z)
                
                shapeColor = Vector3(
                    shapeColor.x > 255 ? 255 : shapeColor.x,
                    shapeColor.y > 255 ? 255 : shapeColor.y,
                    shapeColor.z > 255 ? 255 : shapeColor.z)

                if (firstShape!.isMetallic) {
                    let ray = getRayReflectionVectorWith(shape: firstShape!, withRay: withRay, atIntersection: firstIntersection!, withBounceCount: withBounceCount);
                    let metallicColor = findFirstIntersection(ray.intersection, withRay: ray.dir, withShadow: true, withBounceCount: withBounceCount - 1)
                    
                    shapeColor = shapeColor * (1.0 - firstShape!.reflectiveValue) + metallicColor * firstShape!.reflectiveValue
                }

                return shapeColor
            }
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
    
    private func getRayReflectionVectorWith(shape firstShape:Shape, withRay:Vector3, atIntersection firstIntersection:Vector3, withBounceCount:Int)
        -> (dir:Vector3, intersection:Vector3) {
        let norm = firstShape.normal(firstIntersection)!
        let incomingRay = withRay * -1
        let rayDir = ((norm * ((incomingRay.dot(norm)) * 2) - incomingRay)).normalize()
        let intersection = firstIntersection + rayDir * 0.001
        return (rayDir, intersection)

    }
}