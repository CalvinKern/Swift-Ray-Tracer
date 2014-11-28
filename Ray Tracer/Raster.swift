//
//  Raster.swift
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

import Foundation

public class Raster
{
    private var _width:Int = 0;
    private var _height:Int = 0;
    private var _data:[UInt32] = Array<UInt32>();
    
    init(_ width:Int, _ height:Int, _ fillColor:UInt32 = 0)
    {
        _width = width;
        _height = height;
        fill(fillColor);
    }
    
    init(_ path:String)
    {
        loadBitmap(path)
    }
    
    public var width:Int
    {
            return _width;
    }
    
    public var height:Int
        {
            return _height;
    }
    
    public func fill(color:UInt32)
    {
        _data = Array<UInt32>(count:width * height, repeatedValue:color);
    }
    
    public func loadBitmap(path:String)
    {
        var widthPointer:UnsafeMutablePointer<Int32> = UnsafeMutablePointer<Int32>.alloc(1)
        var heightPointer:UnsafeMutablePointer<Int32> = UnsafeMutablePointer<Int32>.alloc(1)
        var pixelDataPointerPointer:UnsafeMutablePointer<UnsafeMutablePointer<UInt32>> = UnsafeMutablePointer<UnsafeMutablePointer<UInt32>>.alloc(1)
        LoadBitmap(path, widthPointer, heightPointer, pixelDataPointerPointer)
        
        _width = Int(widthPointer.memory);
        _height = Int(heightPointer.memory);
        if (_width <= 0 || _height <= 0)
        {
            _width = 0;
            _height = 0;
            _data = Array<UInt32>();
        }
        var pixelDataPointer:UnsafeMutablePointer<UInt32> = pixelDataPointerPointer.memory;
        
        _data = Array<UInt32>(count:_width * _height, repeatedValue:0)
        for (var y:Int = 0; y < _height; y++)
        {
            for (var x:Int = 0; x < _width; x++)
            {
                _data[y * _width + x] = pixelDataPointer.memory;
                pixelDataPointer = pixelDataPointer.advancedBy(1);
            }
        }
    }
    
    public func saveBitmap(path:String)
    {
        SaveBitmap(path, Int32(_width), Int32(_height), _data)
        
        //        var bitmapData:NSMutableData = NSMutableData();
        //
        //        // Define header data
        //        var magicNumber:UInt16 = 0x4D42;
        //        var reserved0:UInt16 = 0;//0x4D41;
        //        var reserved1:UInt16 = 0;//0x5454;
        //        var dataOffset:UInt32 = 54;
        //        var infoHeaderSize:UInt32 = 40;
        //        var width:Int32 = Int32(_width);
        //        var height:Int32 = Int32(-_height);
        //        var colorPlanes:UInt16 = 1;
        //        var bitsPerPixel:UInt16 = 32;
        //        var compression:UInt32 = 0;
        //        var dataSize:UInt32 = UInt32(width * height * Int32(bitsPerPixel) / 8);
        //        var horizontalResolution:UInt32 = 2835;
        //        var verticalResolution:UInt32 = 2835;
        //        var paletteColorCount:UInt32 = 0;
        //        var importantPaletteColorCount:UInt32 = 0;
        //        var fileSize:UInt32 = 54 + dataSize;
        //
        //        // Write BMP header (Windows V3, 32bbp)
        //        bitmapData.appendBytes([UInt16]([magicNumber]), length:1)
        //        bitmapData.appendBytes([UInt32]([fileSize]), length:sizeof(UInt32))
        //        bitmapData.appendBytes([UInt16]([reserved0]), length:sizeof(UInt16))
        //        bitmapData.appendBytes([UInt16]([reserved1]), length:sizeof(UInt16))
        //        bitmapData.appendBytes([UInt32]([dataOffset]), length:sizeof(UInt32))
        //        bitmapData.appendBytes([UInt32]([infoHeaderSize]), length:sizeof(UInt32))
        //        bitmapData.appendBytes([Int32]([width]), length:sizeof(Int32))
        //        bitmapData.appendBytes([Int32]([height]), length:sizeof(Int32))
        //        bitmapData.appendBytes([UInt16]([colorPlanes]), length:sizeof(UInt16))
        //        bitmapData.appendBytes([UInt16]([bitsPerPixel]), length:sizeof(UInt16))
        //        bitmapData.appendBytes([UInt32]([compression]), length:sizeof(UInt32))
        //        bitmapData.appendBytes([UInt32]([dataSize]), length:sizeof(UInt32))
        //        bitmapData.appendBytes([UInt32]([horizontalResolution]), length:sizeof(UInt32))
        //        bitmapData.appendBytes([UInt32]([verticalResolution]), length:sizeof(UInt32))
        //        bitmapData.appendBytes([UInt32]([paletteColorCount]), length:sizeof(UInt32))
        //        bitmapData.appendBytes([UInt32]([importantPaletteColorCount]), length:sizeof(UInt32))
        //
        //        // Write BMP body
        //        for (var y:Int = 0; y < _height; y++)
        //        {
        //            for (var x:Int = 0; x < _width; x++)
        //            {
        //                let pixel:UInt32 = _data[y * _width + x]
        //                //fwrite(&pixel, sizeof(pixel), 1, file)
        //                bitmapData.appendBytes([UInt32]([pixel]), length:sizeof(UInt32))
        //            }
        //        }
    }
    
    subscript (x: Int, y: Int) -> UInt32
        {
        get
        {
            return _data[y * _width + x]
        }
        set (color)
        {
            _data[y * _width + x] = color
        }
    }
}
