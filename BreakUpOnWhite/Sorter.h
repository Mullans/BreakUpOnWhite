//
//  Sorter.h
//  BreakUpOnWhite
//
//  Created by Sean Mullan on 8/18/14.
//  Copyright (c) 2014 SilentLupin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Document.h"

@interface Sorter : NSObject

+(NSArray *)mergeSort:(NSArray *)input options:(int)options;
    
@end
