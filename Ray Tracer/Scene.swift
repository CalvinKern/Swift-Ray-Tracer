//
//  Scene.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/27/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

private let _SingletonSharedInstance = Scene()

public class Scene  {
    class var sharedInstance : Scene {
        return _SingletonSharedInstance
    }

    private var shapes:Array<Shape> = Array<Shape>()
    private var eye:Vector3 = Vector3(0,0,0)
    private var light:PointLight = PointLight(point: Vector3(0,0,0))

    public var eyePosition:Vector3 {
        get {
            return Vector3(copyVector: eye)
        }
        set (newEyePosition){
            eye = Vector3(copyVector: newEyePosition)
        }
    }
    
    public var lightPosition:Vector3 {
        get {
            return Vector3(copyVector: light.lightPosition)
        }
        set (newLightPosition) {
            light.lightPosition = Vector3(copyVector: newLightPosition)
        }
    }
    
    public var lightColor:Vector3 {
        get {
            return light.material.color
        }
    }
    
    init() {
//        shapes.append(light)
    }
    
    public func add(shape:Shape) {
        shapes.append(shape)
    }
    
    public func getShapes() -> Array<Shape> {
        return Array<Shape>(shapes)
    }
    
    public func printlnVector(vec:Vector3) {
        println(NSString(format: "(%f, %f, %f)", vec.x, vec.y, vec.z))
    }
}



//