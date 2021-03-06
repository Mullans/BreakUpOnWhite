//
//  Document.m
//  BreakUpOnWhite
//
//  Created by Sean Mullan on 8/14/14.
//  Copyright (c) 2014 SilentLupin. All rights reserved.
//

#import "Document.h"
@implementation Document

-(id)initWithOriginal:(NSURL *)input threshold:(int)threshold{
    original = input;
    NSFileManager *man = [NSFileManager defaultManager];
    NSDictionary *attrs = [man attributesOfItemAtPath: [input path] error: NULL];
    unsigned long result = [attrs fileSize];
    if(result>1000000){
        originalSize = [NSString stringWithFormat:@"%.1fMB",result/1000000.0];
    }else{
        originalSize = [NSString stringWithFormat:@"%.1fKB",result/1000.0];
    }
    
    //Checks to see if the image is white or not
    @autoreleasepool {
        NSImage *image = [[NSImage alloc]initWithContentsOfURL:input];
        NSData *imageData = [image TIFFRepresentation];
        CFDataRef imageDataRef = (__bridge CFDataRef)(imageData);
        const UInt8 *pixels = CFDataGetBytePtr(imageDataRef);
        int bytesPerPixel = 4;
        long unsigned int redTotal = 0;
        long unsigned int greenTotal = 0;
        long unsigned int blueTotal = 0;
        long unsigned int total = 0;
        for(int x = 0; x < image.size.width; x++) {
            for(int y = 0; y < image.size.height; y++) {
                int pixelStartIndex = (x + (y * image.size.width)) * bytesPerPixel;
                UInt8 redVal = pixels[pixelStartIndex + 1];
                UInt8 greenVal = pixels[pixelStartIndex + 2];
                UInt8 blueVal = pixels[pixelStartIndex + 3];
                
                redTotal+=redVal;
                greenTotal+=greenVal;
                blueTotal+=blueVal;
                total+=1;
            }
        }
        redTotal = redTotal/total;
        greenTotal = greenTotal/total;
        blueTotal = blueTotal/total;
        rgb = (redTotal+blueTotal+greenTotal)/3;
    }
    
    return self;
}

-(NSURL *)getOriginal{
    return original;
}

-(NSString *)getOriginalSize{
    return originalSize;
}
-(int)getRGB{
    return rgb;
}
@end
