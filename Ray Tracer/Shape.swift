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
    
    public func getIntersection(ray:Vector3) -> Vector3? {
        return nil
    }
}