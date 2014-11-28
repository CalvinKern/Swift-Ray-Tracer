//
//  main.swift
//  Ray Tracer          
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation


class Tracer
{
    // Scene parameters
    var width:Int = 512
    var height:Int = 512
    
    var eye:Vector3 = Vector3(0,0,-5)
    var lookAt:Vector3 = Vector3(0,0,0)
    var up:Vector3 = Vector3(0,-1,0)
    var light:Vector3 = Vector3(0, 10, 0)
    var distance:Float = 1

    var eyeDirection:Vector3 = Vector3(0,0,0)
    var screenCenter:Vector3 = Vector3(0,0,0)
    var screenU:Vector3 = Vector3(0,0,0)
    var screenV:Vector3 = Vector3(0,0,0)
    
    var quarter:Bool = false;
    var half:Bool = false;
    var thirdQuarter:Bool = false;
    
    init() {
        initScreenVectors()
        initScene()

        var raster:Raster = Raster(width, height)
        println("Start casting")
        for (var y:Int = 0; y < height; y++) {
            if (!quarter && Float(y)/Float(height) >= 0.25) {
                quarter = true;
                println("25%")
            } else if (!half && Float(y)/Float(height) >= 0.5) {
                half = true;
                println("50%")
            } else if (!thirdQuarter && Float(y)/Float(height) >= 0.75) {
                thirdQuarter = true;
                println("75%")
            }
            
            for (var x:Int = 0; x < width; x++) {

                var rayDirection = getRayDirection(x, pixelPositionY: y)
                var ray = Ray(fromEye: eye, direction:rayDirection)

//                if (y % 170 == 0 && x % 170 == 0) {
//                if (y == 0 && x % 20 == 0) {
//                    print("Ray: ")
//                    printlnVector(rayDirection)
//                }

                raster[x, y] = convertToHex(ray.getColor())
            }
        }
        println("Done casting")
        raster.saveBitmap("bitmapOutput.bmp")
//        raster.loadBitmap("bitmapOutput.bmp")
    }
    
    private func initScreenVectors() {
        self.eyeDirection = (self.lookAt - self.eye).normalize()
        self.screenCenter = self.eyeDirection * self.distance

        var rEyeDirection:Vector3 = self.eyeDirection * -1

        screenU = rEyeDirection.cross(up).normalize()
        screenV = screenU.cross(rEyeDirection).normalize()
    }
    
    private func initScene() {
        var scene:Scene = Scene.sharedInstance;
        
        scene.eyePosition = self.eye
        scene.lightPosition = self.light
        
        var sphere:Sphere = Sphere(Vector3(0,0.5,0), 1.0, Vector3(255,0,0));
        scene.add(sphere)
    }
    
    private func printlnVector(vec:Vector3) {
        println(NSString(format: "(%f, %f, %f)", vec.x, vec.y, vec.z))
    }

    private func getRayDirection(pixelPositionX:Int, pixelPositionY:Int) -> Vector3 {
        var size:Float = (0.5 * 2 * self.distance)
        var aspect:Float = size/Float(self.width)
        var u:Vector3 = (screenU * (Float(pixelPositionX) * aspect))
        var v:Vector3 = (screenV * (Float(pixelPositionY) * aspect))

        u = Vector3(u.x + size/2, u.y, u.z)
        v = Vector3(v.x, v.y + size/2, v.z)

        return (screenCenter + u + v).normalize()
    }
    
    private func convertToHex(material:Vector3) ->UInt32{
        return 0xFF000000 | UInt32(material.x) << 16 | UInt32(material.y) << 8 | UInt32(material.z)
    }
}

Tracer()


//