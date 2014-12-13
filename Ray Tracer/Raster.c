//
//  Raster.c
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

#include "Raster.h"
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

void LoadBitmap(const char* path, int* bitmapWidth, int* bitmapHeight, uint32_t** bitmapData)
{
    //BMP (Windows V3)
    //Offset    Size    Description
    //0         2       the magic number used to identify the BMP file: 0x42 0x4D (Hex code points for B and M in big-endian order)
    //2         4       the size of the BMP file in bytes
    //6         2       reserved; actual value depends on the application that creates the image
    //8         2       reserved; actual value depends on the application that creates the image
    //10        4       the offset, i.e. starting address, of the byte where the bitmap data can be found.
    //14        4       the size of this header (40 bytes)
    //18        4       the bitmap width in pixels (signed integer).
    //22        4       the bitmap height in pixels (signed integer).
    //26        2       the number of color planes being used. Must be set to 1.
    //28        2       the number of bits per pixel, which is the color samplesPerPixel of the image. Typical values are 1, 4, 8, 16, 24 and 32.
    //30        4       the compression method being used. See the next table for a list of possible values.
    //34        4       the image size. This is the size of the raw bitmap data (see below), and should not be confused with the file size.
    //38        4       the horizontal resolution of the image. (pixel per meter, signed integer)
    //42        4       the vertical resolution of the image. (pixel per meter, signed integer)
    //46        4       the number of colors in the color palette, or 0 to default to 2n.
    //50        4       the number of important colors used, or 0 when every color is important; generally ignored.
    
    // Open file for reading
    FILE* f = fopen(path, "r");
    if (f == NULL)
        return;
    
    // Define header data
    uint16_t magicNumber = 0x4D42;
    uint32_t fileSize = 0;
    uint16_t reserved0 = 0;//0x4D41;
    uint16_t reserved1 = 0;//0x5454;
    uint32_t dataOffset = 54;
    uint32_t infoHeaderSize = 40;
    int32_t width = 0;
    int32_t height = 0;
    //uint16_t colorPlanes = 1;
    //uint16_t bitsPerPixel = 32;
    //uint32_t compression = 0;
    //uint32_t dataSize = width * height * bitsPerPixel / 8;
    //int32_t horizontalResolution = 2835;
    //int32_t verticalResolution = 2835;
    //uint32_t paletteColorCount = 0;
    //uint32_t importantPaletteColorCount = 0;
    
    // Read header data
    fread(&magicNumber, sizeof(uint16_t), 1, f);
    fread(&fileSize, sizeof(uint32_t), 1, f);
    fread(&reserved0, sizeof(uint16_t), 1, f);
    fread(&reserved1, sizeof(uint16_t), 1, f);
    fread(&dataOffset, sizeof(uint32_t), 1, f);
    fread(&infoHeaderSize, sizeof(uint32_t), 1, f);
    fread(&width, sizeof(int32_t), 1, f);
    fread(&height, sizeof(int32_t), 1, f);
    fseek(f, dataOffset, SEEK_SET);
    //fread(&colorPlanes, sizeof(uint16_t), 1, f);
    //fread(&bitsPerPixel, sizeof(uint16_t), 1, f);
    //fread(&compression, sizeof(uint32_t), 1, f);
    //fread(&dataSize, sizeof(uint32_t), 1, f);
    //fread(&horizontalResolution, sizeof(uint32_t), 1, f);
    //fread(&verticalResolution, sizeof(uint32_t), 1, f);
    //fread(&paletteColorCount, sizeof(uint32_t), 1, f);
    //fread(&importantPaletteColorCount, sizeof(uint32_t), 1, f);
    
    //TODO: Check header for sanity, support non-32bpp
    
    // Verify width and height
    bool flip = height > 0;
    width = width < 0 ? -width : width;
    height = height < 0 ? -height : height;
    if (width <= 0 || height <= 0)
        return;

    // Allocate raster
    *bitmapWidth = width;
    *bitmapHeight = height;
    *bitmapData = malloc(sizeof(uint32_t) * width * height);
    
    // Read BMP body
    for (int y = (flip ? height - 1 : 0); (flip ? (y >= 0) : (y < height)); flip ? y-- : y++)
    {
        for (int x = 0; x < width; x++)
        {
            uint32_t pixel = 0;
            fread(&pixel, sizeof(uint32_t), 1, f);
            (*bitmapData)[y * width + x] = pixel;
        }
    }
    
    // Cleanup
    fclose(f);
}

void SaveBitmap(const char* path, int bitmapWidth, int bitmapHeight, const uint32_t* bitmapData)
{
    //BMP (Windows V3)
    //Offset    Size    Description
    //0         2       the magic number used to identify the BMP file: 0x42 0x4D (Hex code points for B and M in big-endian order)
    //2         4       the size of the BMP file in bytes
    //6         2       reserved; actual value depends on the application that creates the image
    //8         2       reserved; actual value depends on the application that creates the image
    //10        4       the offset, i.e. starting address, of the byte where the bitmap data can be found.
    //14        4       the size of this header (40 bytes)
    //18        4       the bitmap width in pixels (signed integer).
    //22        4       the bitmap height in pixels (signed integer).
    //26        2       the number of color planes being used. Must be set to 1.
    //28        2       the number of bits per pixel, which is the color samplesPerPixel of the image. Typical values are 1, 4, 8, 16, 24 and 32.
    //30        4       the compression method being used. See the next table for a list of possible values.
    //34        4       the image size. This is the size of the raw bitmap data (see below), and should not be confused with the file size.
    //38        4       the horizontal resolution of the image. (pixel per meter, signed integer)
    //42        4       the vertical resolution of the image. (pixel per meter, signed integer)
    //46        4       the number of colors in the color palette, or 0 to default to 2n.
    //50        4       the number of important colors used, or 0 when every color is important; generally ignored.
    
    // Open file for writing
    FILE* file = fopen(path, "w");
    if (file == NULL)
        return;
    
    // Define header data
    uint16_t magicNumber = 0x4D42;
    uint16_t reserved0 = 0;//0x4D41;
    uint16_t reserved1 = 0;//0x5454;
    uint32_t dataOffset = 54;
    uint32_t infoHeaderSize = 40;
    int32_t width = bitmapWidth;
    int32_t height = -bitmapHeight;
    uint16_t colorPlanes = 1;
    uint16_t bitsPerPixel = 32;
    uint32_t compression = 0;
    uint32_t dataSize = width * height * bitsPerPixel / 8;
    uint32_t horizontalResolution = 2835;
    uint32_t verticalResolution = 2835;
    uint32_t paletteColorCount = 0;
    uint32_t importantPaletteColorCount = 0;
    uint32_t fileSize = 54 + dataSize;
    
    // Write BMP header (Windows V3, 32bbp)
    fwrite(&magicNumber, sizeof(magicNumber), 1, file);
    fwrite(&fileSize, sizeof(fileSize), 1, file);
    fwrite(&reserved0, sizeof(reserved0), 1, file);
    fwrite(&reserved1, sizeof(reserved1), 1, file);
    fwrite(&dataOffset, sizeof(dataOffset), 1, file);
    fwrite(&infoHeaderSize, sizeof(infoHeaderSize), 1, file);
    fwrite(&width, sizeof(width), 1, file);
    fwrite(&height, sizeof(height), 1, file);
    fwrite(&colorPlanes, sizeof(colorPlanes), 1, file);
    fwrite(&bitsPerPixel, sizeof(bitsPerPixel), 1, file);
    fwrite(&compression, sizeof(compression), 1, file);
    fwrite(&dataSize, sizeof(dataSize), 1, file);
    fwrite(&horizontalResolution, sizeof(horizontalResolution), 1, file);
    fwrite(&verticalResolution, sizeof(verticalResolution), 1, file);
    fwrite(&paletteColorCount, sizeof(paletteColorCount), 1, file);
    fwrite(&importantPaletteColorCount, sizeof(importantPaletteColorCount), 1, file);
    
    // Write BMP body
    for (int y = 0; y < bitmapHeight; y++)
    {
        for (int x = 0; x < bitmapWidth; x++)
        {
            uint32_t pixel = bitmapData[y * bitmapWidth + x];
            fwrite(&pixel, sizeof(pixel), 1, file);
        }
    }
    
    // Cleanup
    fclose(file);
}

void OpenBitmap() {
    char* name[4];
    name[0] = "sh";
    name[1] = "-c";
    name[2] = "open bitmapOutput.bmp";
//    name[2] = "open /Users/calvinkern/Library/Developer/Xcode/DerivedData/Ray_Tracer-dchgeqgmvwoennabejquhbdfvwfb/Build/Products/Release/bitmapOutput.bmp";
    name[3] = NULL;
    execvp("/bin/sh", name);
}



//
