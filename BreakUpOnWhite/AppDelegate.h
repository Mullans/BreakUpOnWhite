//
//  AppDelegate.h
//  BreakUpOnWhite
//
//  Created by Sean Mullan on 8/14/14.
//  Copyright (c) 2014 SilentLupin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Document.h"
#import "Sorter.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate>
@property (weak) IBOutlet NSTextField *buttonLabel2;
@property (weak) IBOutlet NSTextField *buttonLabel1;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) NSMutableArray *documentArray;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableColumn *tableColumn2;
@property (weak) IBOutlet NSTableColumn *tableColumn1;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSTextField *jpgCount;
@property (weak) IBOutlet NSPopUpButton *sortChoice;

@end
