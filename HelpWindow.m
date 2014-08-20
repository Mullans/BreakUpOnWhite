//
//  HelpWindow.m
//  BreakUpOnWhite
//
//  Created by Sean Mullan on 8/20/14.
//  Copyright (c) 2014 SilentLupin. All rights reserved.
//

#import "HelpWindow.h"

@interface HelpWindow ()

@end

@implementation HelpWindow

-(id)init{
    self = [super initWithWindowNibName:@"HelpWindow"];
    [self.window makeKeyAndOrderFront:self];
    [self.window makeMainWindow];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];


    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
