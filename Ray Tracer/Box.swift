//
//  Box.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 12/1/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

public class Box: Shape {
    private(set) var center = Vector3(0,0,0)
    private(set) var size:Float = 1.0

    private var faces = Array<Plane>()
    
    override init() {
        super.init()
        self.material = Material(Vector3(190, 150, 20))
        initFaces()
    }
    
    init(center:Vector3, color:Vector3) {
        super.init()
        self.center = center
        self.size = 1.0
        self.material = Material(color)
        initFaces()
    }
    
    init(center:Vector3, widthAndHeightSize:Float, color:Vector3) {
        super.init()
        self.center = center
        self.size = widthAndHeightSize
        self.material = Material(color)
        initFaces()
    }
    
    private func initFaces() {
        var size = self.size/2
        
        faces.append(Plane(center: Vector3(center.x, center.y + size, center.z), planeU: Vector3(1,0,0), planeV: Vector3(0,0,-1))) //Top
        faces.append(Plane(center: Vector3(center.x, center.y - size, center.z), planeU: Vector3(-1,0,0), planeV: Vector3(0,0,-1))) //Bottom

        faces.append(Plane(center: Vector3(center.x, center.y, center.z + size), planeU: Vector3(1,0,0), planeV: Vector3(0,1,0))) //Front
        faces.append(Plane(center: Vector3(center.x, center.y, center.z - size), planeU: Vector3(-1,0,0), planeV: Vector3(0,1,0))) //Back
        faces.append(Plane(center: Vector3(center.x + size, center.y, center.z), planeU: Vector3(0,0,-1), planeV: Vector3(0,1,0))) //Right
        faces.append(Plane(center: Vector3(center.x - size, center.y, center.z), planeU: Vector3(0,0,1), planeV: Vector3(0,1,0))) //Left
    }
    
    public override func normal(ofPoint: Vector3) -> Vector3? {
        
        for plane in faces {
            if (plane.validPoint(ofPoint)) {
                return plane.normal(ofPoint)
            }
        }
        return nil
    }
    
    // TODO: additional normal function for optimizing so that you don't have to do a loop every normal through each plane
    
    public override func getIntersection(ray: Vector3, fromPoint: Vector3) -> (t:Float, position:Vector3?) {

        var closestIntersection:Vector3?
        var closestT:Float = 0.0
        
        for plane in faces {
            let intersect = plane.getIntersection(ray, fromPoint: fromPoint)
            if (intersect.position == nil) {
                continue
            }

            if (!plane.pointInBoundedPlane(intersect.position!, withPlaneSize: size)) {
                continue
            }
            
            if (closestIntersection == nil || intersect.t < closestT) {
                closestT = intersect.t
                closestIntersection = intersect.position
            }
        }
        
        if (closestIntersection == nil) {
            return (-1, nil)
        } else {
            return (closestT, closestIntersection)
        }
    }
}




//