//
//  Raster.h
//  Ray_Tracer
//
//  Created by Calvin Kern on 11/26/14.
//  Copyright (c) 2014 Calvin Kern. All rights reserved.
//

#ifndef __Ray_Tracer__Raster__
#define __Ray_Tracer__Raster__

#include <stdlib.h>

void LoadBitmap(const char* path, int* bitmapWidth, int* bitmapHeight, uint32_t** bitmapData);
void SaveBitmap(const char* path, int bitmapWidth, int bitmapHeight, const uint32_t* bitmapData);
void OpenBitmap();

#endif /* defined(__Ray_Tracer__Raster__) */
