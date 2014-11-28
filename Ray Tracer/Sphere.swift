//
//  Sphere.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

public class Sphere: Shape {
    private(set) var center:Vector3 = Vector3(0,0,0)
    private(set) var radius:Float = 1.0
    
    override init() {
        super.init()
        initSphere(Vector3(0,0,0), 1.0, Vector3(256,0,0));
    }
    
    init(_ center:Vector3, _ radius:Float) {
        super.init()
        initSphere(center, radius, Vector3(256,0,0))
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
        return (self.center - ofPoint).normalize()
    }
    
    public override func getIntersection(ray: Vector3, fromPoint: Vector3) -> Vector3? {
        var distance:Vector3 = (fromPoint - self.center)
        
        var a:Float = ray.dot(ray)
        var b:Float = (ray * 2).dot(distance)
        var c:Float = (distance).dot(distance) - (self.radius * self.radius)
        
        var h:Float = (b * b) - 4 * a * c
        
//        println(NSString(format: " - with h: %f", h))
        if ( h >= 0) {
            var pos:Float = (-1 * b + h) / (2 * a)
            var neg:Float = (-1 * b - h) / (2 * a)
            
            var posPoint:Vector3 = fromPoint + (ray * pos)
            var negPoint:Vector3 = fromPoint + (ray * neg)
            
            if (pos < 0) {
                return posPoint
            } else {
                return negPoint
            }
        }
        return nil
    }
}



//