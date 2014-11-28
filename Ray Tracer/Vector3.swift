//
//  Vector.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation
import Darwin

public class Vector3 {
    private(set) var x:Float = 0.0
    private(set) var y:Float = 0.0
    private(set) var z:Float = 0.0

    public init(_ x:Float, _ y:Float, _ z:Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(copyVector:Vector3) {
        self.x = copyVector.x
        self.y = copyVector.y
        self.z = copyVector.z
    }
    
    // magnitude
    public func magnitude() -> Float {
        return Darwin.sqrt((x * x) + (y * y) + (z * z))
    }
    
    // normalize
    public func normalize() -> Vector3 {
        return (self * (1 / magnitude()))
    }
    
    // dot
    public func dot(otherVector:Vector3) -> Float {
        return (self.x * otherVector.x) + (self.y * otherVector.y) + (self.z * otherVector.z);
    }
    
    // cross
    public func cross(otherVector:Vector3) -> Vector3 {
        var x:Float = self.y * otherVector.z - self.z * otherVector.y
        var y:Float = self.z * otherVector.x - self.x * otherVector.z
        var z:Float = self.x * otherVector.y - self.y * otherVector.x
        return Vector3(x, y, z)
    }
}

// add
public func +(left:Vector3, right:Vector3) -> Vector3 {
    return Vector3(left.x + right.x, left.y + right.y, left.z + right.z)
}

// sub
public func -(left:Vector3, right:Vector3) -> Vector3 {
    return Vector3(left.x - right.x, left.y - right.y, left.z - right.z)
}

// scalar mult
public func *(left:Vector3, right:Float) -> Vector3 {
    return Vector3(left.x * right, left.y * right, left.z * right)
}

public func ==(left:Vector3, right:Vector3) -> Bool {
    return (left.x == right.x) && (left.y == right.y) && (left.z == right.z)
}


//