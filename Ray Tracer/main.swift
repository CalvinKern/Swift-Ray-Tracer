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
    let width:Int = 512
    let height:Int = 512
    var pixelSize:Float = 1.0/512.0
    
//    let eye:Vector3 = Vector3(6,8,0)
    let eye:Vector3 = Vector3(0,2,5)
    let lookAt:Vector3 = Vector3(0,0,0)
    let up:Vector3 = Vector3(0,1,0)
    let light:Vector3 = Vector3(6, 4, 2)
    let distance:Float = 1

    var eyeDirection:Vector3 = Vector3(0,0,0)
    var screenCenter:Vector3 = Vector3(0,0,0)
    var bottomLeft:Vector3 = Vector3(0,0,0)
    var screenU:Vector3 = Vector3(0,0,0)
    var screenV:Vector3 = Vector3(0,0,0)
    
    var quarter:Bool = false;
    var half:Bool = false;
    var thirdQuarter:Bool = false;
    
    init() {
        initScreenVectors()
        initScene()

        var raster:Raster = Raster(width, height)
        println("Start ray tracing")
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for (var y:Int = 0; y < height; y++) {
            if (!quarter && Float(y)/Float(height) >= 0.25) {
                quarter = true;
                let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
                println("25%, TIME: \(elapsedTime)")
            } else if (!half && Float(y)/Float(height) >= 0.5) {
                half = true;
                let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
                println("50%, TIME: \(elapsedTime)")
            } else if (!thirdQuarter && Float(y)/Float(height) >= 0.75) {
                thirdQuarter = true;
                let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
                println("75%, TIME: \(elapsedTime)")
            }
            
            for (var x:Int = 0; x < width; x++) {

//                var color = samplePixel(x, pixelPositionY: y) // Takes longer, looks a little better
                var color = singlePixelSample(x, pixelPositionY: y)

                raster[x, (height - 1) - y] = convertToHex(color)
            }
        }
        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
        println("Done ray tracing, TIME: \(elapsedTime)")
        
        raster.saveBitmap("bitmapOutput.bmp")
//        raster.loadBitmap("bitmapOutput.bmp")
    }
    
    // Helper init functions
    private func initScreenVectors() {
        self.eyeDirection = (self.lookAt - self.eye).normalize()
        self.screenCenter = self.eyeDirection * self.distance

        var rEyeDirection:Vector3 = (self.eyeDirection * -1).normalize()

        screenU = up.cross(rEyeDirection).normalize()
        screenV = rEyeDirection.cross(screenU).normalize()
        
        var size:Float = ( 0.577 * 2 * self.distance)
        self.pixelSize = size/512
        self.bottomLeft = screenCenter - (screenU * 0.5 * size) - (screenV * 0.5 * size)
    }
    
    private func initScene() {
        var scene:Scene = Scene.sharedInstance;
        
        scene.eyePosition = self.eye
        scene.lightPosition = self.light
        
//        var lightSphere:Sphere = Sphere(Vector3(2,3,0), 0.5, Vector3(190,0,190))
//        lightSphere.ignoreIntersections = true
//        scene.add(lightSphere)

        var sphereRed:Sphere = Sphere(Vector3(2.0, 0.95, -2.0), 0.3, Vector3(255,0,0))
        scene.add(sphereRed)
        
        var sphereGreen:Sphere = Sphere(Vector3(2.0, 0.5, -2.0), 0.5, Vector3(0,255,0))
        scene.add(sphereGreen)

        var spherePurple:Sphere = Sphere(Vector3(2.0, 0.0, -2.0), 0.6, Vector3(190,0,190))
        scene.add(spherePurple)

        var sphereWhite:Sphere = Sphere(Vector3(0.0, 0.0, -2.0), 0.5, Vector3(255,255,255))
        scene.add(sphereWhite)

        var spherePlane:Sphere = Sphere(Vector3(0.0, -10000.0, 0.0), 9999, Vector3(180, 65, 250))
        scene.add(spherePlane)
        // TODO: add plane
        srand(0)
    }

    private func singlePixelSample(pixelPositionX:Int, pixelPositionY:Int) -> Vector3 {
        var rayDirection = (getRayDirection(Float(pixelPositionX), pixelPositionY: Float(pixelPositionY))).normalize()
        var ray = Ray(fromEye: eye, direction:rayDirection)
        
        return ray.getColor()
    }
    
    // Private helper functions
    private func samplePixel(pixelPositionX:Int, pixelPositionY:Int) -> Vector3 {
        var colors = Array<Vector3>()
        
        var pixelX = Float(pixelPositionX)
        var pixelY = Float(pixelPositionY)
        
        var rayDirection = getRayDirection(pixelX, pixelPositionY: pixelY)

        for (var i:Int = 0; i < 3; i++) {
            for (var j:Int = 0; j < 3; j++) {
                
                // Used for jittering, not quite there
                //                var randX = Float(drand48())
                //                var randY = Float(drand48())
                
                var randX:Float = 0.33
                var randY:Float = 0.33
                var ray = Ray(fromEye: eye, direction:Vector3(rayDirection.x + randX * Float(i), rayDirection.y + randY * Float(j), rayDirection.z))
            
                colors.append(ray.getColor())
            }
        }
        
        var returnColor = Vector3(0,0,0)
        
        for color in colors {
            returnColor = returnColor + color
        }
        return returnColor * (1.0/Float(colors.count))
    }
    
    private func getRayDirection(pixelPositionX:Float, pixelPositionY:Float) -> Vector3 {

        var u:Vector3 = (screenU * (pixelPositionX * pixelSize))
        var v:Vector3 = (screenV * (pixelPositionY * pixelSize))

        return (bottomLeft + u + v)
    }
    
    // Private util functions
    private func printlnVector(vec:Vector3) {
        println(NSString(format: "(%f, %f, %f)", vec.x, vec.y, vec.z))
    }
    
    private func convertToHex(material:Vector3) ->UInt32{
        return 0xFF000000 | UInt32(material.x) << 16 | UInt32(material.y) << 8 | UInt32(material.z)
    }
}

Tracer()


//