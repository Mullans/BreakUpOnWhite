//
//  Sorter.m
//  BreakUpOnWhite
//
//  Created by Sean Mullan on 8/18/14.
//  Copyright (c) 2014 SilentLupin. All rights reserved.
//

#import "Sorter.h"
@implementation Sorter

+(NSArray *)mergeSort:(NSArray *)input options:(int)options{
    int size = [input count];
    if (size>1){
//        NSLog(@"%i->%i  %i->%i  %i",0,size/2,size/2+1,size/2+1+size-size/2-1,size);
        NSArray *left = [input subarrayWithRange: NSMakeRange(0, size/2)];
        left = [self mergeSort:left options:options];
        
        NSArray *right = [input subarrayWithRange:NSMakeRange(size/2,size-size/2)];
        right = [self mergeSort:right options:options];

        return [self merge:left right:right options:options];
//        combine the two
    }else{
        return input;
    }
}
+(NSArray *)merge:(NSArray *)left right:(NSArray*)right options:(int)options{
    int leftCount = 0;
    int rightCount = 0;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    int size = [left count]+[right count];
    while ((leftCount+rightCount)<size){
        if (leftCount>=[left count]){
            [returnArray addObject:[right objectAtIndex:rightCount]];
            rightCount++;
        }else if(rightCount>=[right count]){
            [returnArray addObject:[left objectAtIndex:leftCount]];
            leftCount++;
        }
        else if([self compare:[left objectAtIndex:leftCount] right:[right objectAtIndex:rightCount]options:options]){
            [returnArray addObject:[left objectAtIndex:leftCount]];
            leftCount++;
        }else{
            [returnArray addObject:[right objectAtIndex:rightCount]];
            rightCount++;
        }
    }
    return returnArray;
}

//returns true for left, and false for right
//currently works on file size
//optoins: 0 - date 1 - size 2 - none
+(BOOL)compare:(Document *)left right:(Document *)right options:(int)options{
    if ([[left getOriginal] isEqualTo:@"Missing File"]){
        return false;
    }else if([[right getOriginal] isEqualTo:@"Missing File"]){
        return true;
    }
    NSString* path1 = [[left getOriginal] path];
    NSString* path2 = [[right getOriginal]path];
    if (options == 1){
        NSFileManager *man = [NSFileManager defaultManager];
        NSDictionary *attrs1 = [man attributesOfItemAtPath: path1 error: NULL];
        unsigned long result1 = [attrs1 fileSize];
        NSDictionary *attrs2 = [man attributesOfItemAtPath: path2 error: NULL];
        unsigned long result2 = [attrs2 fileSize];
        if(result1>result2){
            return true;
        }else{
            return false;
        }
    }else if(options ==0){
        NSDictionary* attrs1 = [[NSFileManager defaultManager] attributesOfItemAtPath:path1 error:nil];
        NSDate *result1 = [attrs1 objectForKey:NSFileCreationDate]; //or NSFileModificationDate
        
        NSDictionary* attrs2 = [[NSFileManager defaultManager]attributesOfItemAtPath:path2 error:nil];
        NSDate *result2 = [attrs2 objectForKey:NSFileCreationDate];
        NSComparisonResult result = [result1 compare:result2];
        if(result==NSOrderedAscending){
            return true;
        }else{
            return false;
        }
    }
    
    return true;

}
@end

