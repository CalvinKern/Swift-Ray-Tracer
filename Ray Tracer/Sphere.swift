//
//  Sphere.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation
import Darwin

public class Sphere: Shape {
    private(set) var center:Vector3 = Vector3(0,0,0)
    private(set) var radius:Float = 1.0
    public var ignoreIntersections = false
    private var epsilon:Float = 0
    
    override init() {
        super.init()
        initSphere(Vector3(0,0,0), 1.0, Vector3(255,0,0));
    }
    
    init(_ center:Vector3, _ radius:Float) {
        super.init()
        initSphere(center, radius, Vector3(255,0,0))
    }
    
    init(_ center:Vector3, _ radius:Float, _ color:Vector3) {
        super.init()
        initSphere(center, radius, color)
    }
    
    func initSphere(center:Vector3, _ radius:Float, _ color:Vector3) {
        self.center = center
        self.radius = radius
        self.material = Material(Int(color.x), Int(color.y), Int(color.z))
    }
    
    public override func normal(ofPoint: Vector3) -> Vector3? {
        return (ofPoint - self.center).normalize()
    }
    
    public override func getIntersection(ray: Vector3, fromPoint: Vector3) -> (t:Float, position:Vector3?) {
        if (ignoreIntersections && fromPoint != Scene.sharedInstance.eyePosition) {
            return (-1, nil)
        }
        
        var direction:Vector3 = (fromPoint - self.center)
        
        var a:Float = ray.dot(ray)
        var b:Float = (ray * 2).dot(direction)
        var c:Float = (direction).dot(direction) - (self.radius * self.radius)
        
        var h:Float = (b * b) - (4 * a * c)
        
        if ( h > 0) {
            var pos:Float = (-1 * b + sqrt(h)) / (2 * a)
            var neg:Float = (-1 * b - sqrt(h)) / (2 * a)
            
            if (pos < 0 && neg < 0) {
                return (-1.0, nil);
            }
            
            var posPoint:Vector3 = fromPoint + (ray * pos)
            var negPoint:Vector3 = fromPoint + (ray * neg)

            var negDistance = (negPoint - self.center)
            if (pos > neg) {
                return (neg, negPoint)
            } else {
                return (pos, posPoint)
            }
//            if (fromPoint.squareDistanceTo(posPoint) > fromPoint.squareDistanceTo(negPoint)) {
//                if (neg < 0) {
//                    return posPoint
//                }
//                return negPoint
//            } else if (pos < 0) {
//                return negPoint
//            } else {
//                return posPoint
//            }

        }
        return (-1, nil)
    }
}

//