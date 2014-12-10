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
    private var planeV = Vector3(0,0,-1)
    internal var size:Float?

    override init() {
        super.init()
    }
    
    init(center:Vector3) {
        super.init()
        self.center = center
        self.material = Material(Vector3(150,150,150))
    }
    
    init(center:Vector3, color:Vector3) {
        super.init()
        self.center = Vector3(copyVector: center)
        self.material = Material(Vector3(copyVector: color))
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
            if (t < 0 || t == 0) {
                return (-1, nil)
            }
            let intersectPosition = fromPoint + ray * t

            if (size != nil) {
                if (!pointInBoundedPlane(intersectPosition, withPlaneSize: size!)) {
                    return (-1, nil)
                }
            }
            return (t, intersectPosition)
        }
    }
    
    public func pointInBoundedPlane(withPoint:Vector3, withPlaneSize:Float) -> Bool {
        let size = withPlaneSize/2
        
        let topDirection = (self.center + self.planeU * size) - withPoint
        
        if (topDirection.dot(planeU) < 0) {
            return false
        }
        
        let bottomDirection = (self.center - self.planeU * size) - withPoint

        if (bottomDirection.dot(planeU * -1) < 0) {
            return false
        }
        
        let rightDirection = (self.center + self.planeV * size) - withPoint

        if (rightDirection.dot(planeV) < 0) {
            return false
        }
        
        let leftDirection = (self.center - self.planeV * size) - withPoint

        if (leftDirection.dot(planeV * -1) < 0) {
            return false
        }
        
        return true
    }
    
    public func validPoint(withPoint:Vector3) -> Bool {
        let value = (self.center - withPoint).dot(normal(withPoint)!)
        return (value < 0.0001) && (value > -0.0001)
    }
}




//