//
//  Light.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/28/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

public class PointLight : Shape {
    
    private var position:Vector3 = Vector3(0,0,0)
    
    public var lightPosition:Vector3 {
        get {
            return Vector3(copyVector: self.position)
        }
        set(newLightPosition) {
            self.position = Vector3(copyVector: newLightPosition)
        }
    }
    
    init(point:Vector3) {
        super.init()
        self.position = Vector3(copyVector: point)
        self.material = Material(255,255,255)
    }
    
    public override func getIntersection(ray: Vector3, fromPoint: Vector3) -> (t:Float, position:Vector3?) {
        
        return (-1.0, nil)
    }
}