//
//  Material.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

public class Material {
    
    private(set) var color:Vector3 = Vector3(0,255,0)
    
    public init() {
        
    }
    
    public init( _ red:Int, _ green:Int, _ blue:Int) {
        self.color = Vector3(Float(red), Float(green), Float(blue))
    }
    
    public init(_ color:Vector3) {
        self.color = Vector3(copyVector: color)
    }
}