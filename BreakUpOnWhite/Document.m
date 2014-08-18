//
//  Document.m
//  BreakUpOnWhite
//
//  Created by Sean Mullan on 8/14/14.
//  Copyright (c) 2014 SilentLupin. All rights reserved.
//

#import "Document.h"

@implementation Document
-(id)initWithCopy:(NSURL *)input{
    copy = input;
    original = @"Missing File";
    originalSize = @"N/A";
    NSFileManager *man = [NSFileManager defaultManager];
    NSDictionary *attrs = [man attributesOfItemAtPath: [input path] error: NULL];
    unsigned long result = [attrs fileSize];
    if(result>1000000){
        copySize = [NSString stringWithFormat:@"%.1fMB",result/1000000.0];
    }else{
        copySize = [NSString stringWithFormat:@"%.1fKB",result/1000.0];
    }
    return self;
}
-(id)initWithOriginal:(NSURL *)input{
    original = input;
    copy = @"Missing File";
    copySize = @"N/A";
    NSFileManager *man = [NSFileManager defaultManager];
    NSDictionary *attrs = [man attributesOfItemAtPath: [input path] error: NULL];
    unsigned long result = [attrs fileSize];
    if(result>1000000){
        originalSize = [NSString stringWithFormat:@"%.1fMB",result/1000000.0];
    }else{
        originalSize = [NSString stringWithFormat:@"%.1fKB",result/1000.0];
    }
    return self;
}
-(NSURL *)getCopy{
    return copy;
}
-(void)setCopy:(NSURL *)input{
    NSFileManager *man = [NSFileManager defaultManager];
    NSDictionary *attrs = [man attributesOfItemAtPath: [input path] error: NULL];
    unsigned long result = [attrs fileSize];
    if(result>1000000){
        copySize = [NSString stringWithFormat:@"%.1fMB",result/1000000.0];
    }else{
        copySize = [NSString stringWithFormat:@"%.1fKB",result/1000.0];
    }
    copy = input;
}
-(NSString *)getCopySize{
    return copySize;
}
-(NSURL *)getOriginal{
    return original;
}
-(void)setOriginal:(NSURL *)input{
    NSFileManager *man = [NSFileManager defaultManager];
    NSDictionary *attrs = [man attributesOfItemAtPath: [input path] error: NULL];
    unsigned long result = [attrs fileSize];
    if(result>1000000){
        originalSize = [NSString stringWithFormat:@"%.1fMB",result/1000000.0];
    }else{
        originalSize = [NSString stringWithFormat:@"%.1fKB",result/1000.0];
    }
    original = input;
}
-(NSString *)getOriginalSize{
    return originalSize;
}
@end
