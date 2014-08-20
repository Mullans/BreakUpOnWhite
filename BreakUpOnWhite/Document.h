//
//  Document.h
//  BreakUpOnWhite
//
//  Created by Sean Mullan on 8/14/14.
//  Copyright (c) 2014 SilentLupin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject{
    NSURL *original;
    NSString* originalSize;
}

-(id)initWithOriginal:(NSURL*)input threshold:(int)threshold;
-(NSURL*)getOriginal;
-(NSString*)getOriginalSize;
@end
