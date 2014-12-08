//
//  Material.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation
import Darwin

public class Material {
    
    private var color:Vector3 = Vector3(0,255,0)
    private var checker:Vector3?
    
    public var materialChecker:Vector3? {
        get {
            if (checker != nil) {
                return Vector3(copyVector: checker!)
            } else {
                return nil
            }
        }
        set (value) {
            if (value != nil) {
                checker = Vector3(copyVector: value!)
            } else {
                checker = nil
            }
        }
    }
    public init() {
        
    }
    
    public init( _ red:Int, _ green:Int, _ blue:Int) {
        self.color = Vector3(Float(red), Float(green), Float(blue))
    }
    
    public init(_ color:Vector3) {
        self.color = Vector3(copyVector: color)
    }
    
    public init( materialColor:Vector3, checkerColor:Vector3) {
        self.color = Vector3(copyVector: materialColor)
        self.checker = Vector3(copyVector: checkerColor)
    }
    
    public func getMaterialColor(withPoint:Vector3) -> Vector3 {
        if (checker != nil) {
           if (abs(floorf(withPoint.x) % 2) == 0 &&
            abs(floorf(withPoint.z) % 2) == 0) {
                return Vector3(copyVector: checker!)
           } else if (abs(floorf(withPoint.x) % 2) == 1 && abs(floorf(withPoint.z) % 2) == 1) {
                return Vector3(copyVector: checker!)
           }
        }
        return Vector3(copyVector: color)
    }
}




//