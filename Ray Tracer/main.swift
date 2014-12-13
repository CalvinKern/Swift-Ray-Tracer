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
    var pixelSize:Float = 512
    var samplesPerPixel:Int = 1
    
    //    var eye:Vector3 = Vector3(0.25,1.5,0.3)
    var eye:Vector3 = Vector3(1,1.5,5)
//        var eye:Vector3 = Vector3(7,5,2)
//    var eye:Vector3 = Vector3(0,0,0)
    
    let lookAt:Vector3 = Vector3(0,0,0)
    let up:Vector3 = Vector3(0,1,0)
    var light:Vector3 = Vector3(2, 4, 2)
    let distance:Float = 1
    
    var eyeDirection:Vector3 = Vector3(0,0,0)
    var screenCenter:Vector3 = Vector3(0,0,0)
    var bottomLeft:Vector3 = Vector3(0,0,0)
    var screenU:Vector3 = Vector3(0,0,0)
    var screenV:Vector3 = Vector3(0,0,0)
    
    var quarter:Bool = false;
    var half:Bool = false;
    var thirdQuarter:Bool = false;
    
    let help = "\nUsage: ./Ray_Tracer [-e <%f,%f,%f>] [-l <%f,%f,%f>] [-s <%f>]\n\nOptions:\n\n\t-e\t\tSets the eye position (separated by ,)\n\t-l\t\tSets the light position (separated by ,)\n\t-s\t\tSets the number of row and column samples per pixel\n\t\t\t(gets very slow; default is 1 - max is 5 to ensure it doesn't take an hour)\n"
    
    init() {
        if (!parseCommandLineParams()) {
            return
        }
        
        initScreenVectors()
        initScene()
        
        runRaster()
    }
    
    private func parseCommandLineParams() -> Bool {
        var lastArgument:String = ""
        var skipCount = 1;
        
        var eyeArray = [Float]()
        var lightArray = [Float]()
        
        for argument in Process.arguments {
            if (skipCount != 0) {
                skipCount--
                
                if (lastArgument == "-e") {
                    eye = parseFloatVector(argument)
                    if (eye.normalize() == Vector3(0,1,0) || eye.normalize() == Vector3(0,-1,0)) {
                        eye = Vector3(0.1,eye.y,0)
                    }
                } else if (lastArgument == "-l") {
                    light = parseFloatVector(argument)
                } else if (lastArgument == "-s") {
                    let val = argument.toInt()
                    if (val == nil) {
                        return false
                    } else {
                        self.samplesPerPixel = val!
                        if (val > 5) {
                            self.samplesPerPixel = 5
                        }
                    }
                }
                continue
            }
            
            lastArgument = argument
            
            switch argument {
            case "-e":
                skipCount = 1
                
            case "-l":
                skipCount = 1
                
            case "-s":
                skipCount = 1
                
            case "-h":
                println(self.help)
                return false
            
            default:
                println("Unkown argument: " + argument)
                return false
            }
        }

        return true
    }
    
    private func parseFloatVector(argument:String) -> Vector3 {
        let args = argument.componentsSeparatedByString(",")
        return Vector3(parseFloat(args[0]), parseFloat(args[1]), parseFloat(args[2]))
    }
    
    private func parseFloat(argument:String) -> Float {
        return (argument as NSString).floatValue
    }
    private func runRaster() {
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
            
            var color:Vector3;
            for (var x:Int = 0; x < width; x++) {
                
                var color:Vector3
                if (samplesPerPixel == 1) {
                    color = singlePixelSample(x, pixelPositionY: y)
                } else {
                    color = samplePixel(x, pixelPositionY: y) // Takes longer, looks better
                }
                
                raster[x, (height - 1) - y] = convertToHex(color)
            }
        }
        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
        println("Done ray tracing, TIME: \(elapsedTime)")
        
        raster.saveBitmap("bitmapOutput.bmp")
        println("Opening Bitmap")
        raster.openBitmap()
    }
    
    // Helper init functions
    private func initScreenVectors() {
        self.eyeDirection = (self.lookAt - self.eye).normalize()
        self.screenCenter = self.eyeDirection * self.distance
        
        var rEyeDirection:Vector3 = (self.eyeDirection * -1).normalize()
        
        screenU = up.cross(rEyeDirection).normalize()
        screenV = rEyeDirection.cross(screenU).normalize()
        
        var size:Float = ( 0.577 * 2 * self.distance)
        self.pixelSize = size/self.pixelSize
        self.bottomLeft = screenCenter - (screenU * 0.5 * size) - (screenV * 0.5 * size)
    }
    
    private func initScene() {
        var scene:Scene = Scene.sharedInstance;
        
        scene.eyePosition = self.eye
        scene.lightPosition = self.light
        
        let snowmanX:Float = 1.0
        let snowmanZ:Float = 0.0
        let sphereRed:Sphere = Sphere(Vector3(snowmanX, 1.55, snowmanZ), 0.3, Vector3(255,0,0))
        scene.add(sphereRed)
        
        let sphereGreen:Sphere = Sphere(Vector3(snowmanX, 1.0, snowmanZ), 0.5, Vector3(0,255,0))
        sphereGreen.isMetallic = true
        sphereGreen.reflectiveValue = 0.4
        scene.add(sphereGreen)
        
        let spherePurple:Sphere = Sphere(Vector3(snowmanX, 0.5, snowmanZ), 0.6, Vector3(190,0,190))
        scene.add(spherePurple)
        
        let sphereMirror:Sphere = Sphere(Vector3(-0.25, 1.5, 0.25), 0.3, Vector3(255,255,255))
        sphereMirror.isMetallic = true
        sphereMirror.reflectiveValue = 0.9
        scene.add(sphereMirror)
        
        let plane = Plane(center: Vector3(0,0,0), color: Vector3(250,250,0))
        plane.size = 8
        plane.material.materialChecker = Vector3(0,0,0)
        scene.add(plane)
        
        let box = Box(center: Vector3(-0.5,0.5,0.25), color: Vector3(190, 150, 20))
        box.isMetallic = true;
        box.reflectiveValue = 0.1
        scene.add(box)
        
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
        
        var pixelX = Float(pixelPositionX) - 0.5
        var pixelY = Float(pixelPositionY) - 0.5
        
        let sampleCount:Float = Float(samplesPerPixel)
        let sampleSquared:Float = (sampleCount * sampleCount)
        for (var i:Float = 0; i < sampleCount; i++) {
            for (var j:Float = 0; j < sampleCount; j++) {
                
                // Used for jittering, not quite there
                var randX = Float(drand48())/sampleSquared
                var randY = Float(drand48())/sampleSquared
                
                let percentX:Float = (i + 1)/sampleCount
                let percentY:Float = (j + 1)/sampleCount
                
                var rayDirection = getRayDirection(pixelX + percentX + randX, pixelPositionY: pixelY + percentY + randY)
                
                var ray = Ray(fromEye: eye, direction:Vector3(rayDirection.x, rayDirection.y, rayDirection.z))
                
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