//
//  Shape.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

public class Shape {
    internal(set) var material:Material = Material()
    
    init() {
        
    }

    public func getIntersection(withRay:Vector3, fromPoint:Vector3) ->Vector3? {
        return nil
    }
    
    public func normal(ofPoint:Vector3) -> Vector3? {
        return nil
    }
}