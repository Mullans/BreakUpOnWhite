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
#import "HelpWindow.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *buttonLabel1;
@property (weak) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableColumn *tableColumn2;
@property (weak) IBOutlet NSTableColumn *tableColumn1;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSTextField *jpgCount;
@property (weak) IBOutlet NSPopUpButton *sortChoice;
@property (weak) IBOutlet NSProgressIndicator *progress;
@property (weak) IBOutlet NSTextField *thresholdText;
@property (weak) IBOutlet NSStepper *stepperValue;

@property (strong) NSMutableArray *documentArray;
@property int whiteThreshold;
@property (strong)HelpWindow* helpwindow;
@end
