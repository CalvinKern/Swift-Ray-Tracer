//
//  Plane.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 12/1/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

public class Plane: Shape {

    private(set) var center = Vector3(0,0,0)
    private var planeU = Vector3(1,0,0)
    private var planeV = Vector3(0,1,0)

    override init() {
        super.init()
    }
    
    init(center:Vector3) {
        super.init()
        self.center = center
    }
    
    init(center:Vector3, planeU:Vector3, planeV:Vector3) {
        super.init()
        self.center = center
        self.planeU = planeU
        self.planeV = planeV
    }

    public override func normal(ofPoint: Vector3) -> Vector3? {
        return (planeU.cross(planeV)).normalize()
    }
    
    public override func getIntersection(ray: Vector3, fromPoint: Vector3) -> (t:Float, position:Vector3?) {
        
        var normalPoint = normal(Vector3(0,0,0))!
        var top = (self.center - fromPoint).dot(normalPoint)
        var bottom = ray.dot(normalPoint)
        
        if (bottom == 0) {
            return (-1, nil)
        } else {
            var t = top / bottom
            return (t, fromPoint + ray * t)
        }
    }
}




//