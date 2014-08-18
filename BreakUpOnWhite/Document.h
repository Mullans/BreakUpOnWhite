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
    NSURL *copy;
    NSString* originalSize;
    NSString* copySize;
}

-(id)initWithOriginal:(NSURL*)input;
-(id)initWithCopy:(NSURL*)input;
-(NSURL*)getOriginal;
-(NSURL*)getCopy;
-(void)setCopy:(NSURL*)input;
-(void)setOriginal:(NSURL*)input;
-(NSString*)getOriginalSize;
-(NSString*)getCopySize;
@end
