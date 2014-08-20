//
//  AppDelegate.m
//  BreakUpOnWhite
//
//  Created by Sean Mullan on 8/14/14.
//  Copyright (c) 2014 SilentLupin. All rights reserved.
//

#import "AppDelegate.h"
@implementation AppDelegate
- (IBAction)loadingButton1:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setTitle:@"Choose TIFF folder"];
    NSArray  *fileTypes = [NSArray arrayWithObjects:@"tif",nil];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:fileTypes];
    
    
    NSInteger clicked = [panel runModal];
    //This runs if the ok button was clicked on the open panel.
    [_progress startAnimation:self];
    if (clicked == NSFileHandlingPanelOKButton) {
        
        //This section sets and resizes the label to reflect the users choice.
        [_buttonLabel1  setStringValue:[[panel URL]path]];
        [_buttonLabel1 sizeToFit];
        [_buttonLabel1 setFrameOrigin:CGPointMake(self.window.frame.size.width/2-_buttonLabel1.frame.size.width/2, _buttonLabel1.frame.origin.y)];
        
        //This gets all of the files from the selected directory, and skips hidden files.
        NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[panel URL] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        for(NSURL* item in dirs){
            //check to see if there is a document of the same name in original
            BOOL sentinel = YES;
            if (![[item pathExtension] isEqual:@"tif"]){
                continue;
            }
            for(Document *doc in _documentArray){
                @try{
                    if([[item path] isEqualToString:[[doc getOriginal]path]]){
                        sentinel = NO;
                        break;
                    }
                }@catch(NSException *exception){
                    NSLog(@"Error 2");
                }
            }
            if (sentinel){
                Document *newDocument = [[Document alloc]initWithOriginal:item threshold:_whiteThreshold];
                [_documentArray addObject:newDocument];
            }
        }
    }
    _jpgCount.stringValue = [NSString stringWithFormat:@"%lu Images",(unsigned long)[_documentArray count]];
    _documentArray = [[NSMutableArray alloc]initWithArray:[Sorter mergeSort:_documentArray options:_sortChoice.indexOfSelectedItem]];
    [_tableView reloadData];
    [_progress stopAnimation:self];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return _documentArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    
    // There is no existing cell to reuse so we will create a new one
    if (result == nil) {
        result = [[NSTableCellView alloc] initWithFrame:NSMakeRect(0, 0, tableView.bounds.size.width, [tableView rowHeight])];
    }

    // result is now guaranteed to be valid, either as a re-used cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
    NSTextField *cellTF = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, tableColumn.width, result.bounds.size.height)];
    [result addSubview:cellTF];
    result.textField = cellTF;
    [cellTF setBordered:NO];
    [cellTF setEditable:NO];
    [cellTF setDrawsBackground:NO];
//    NSLog(@"column: %@    row: %ld",tableColumn.identifier,(long)row);
    Document *newDocument = [_documentArray objectAtIndex:row];
    if ([tableColumn.identifier isEqual:@"1"]){
        result.textField.stringValue = [[newDocument getOriginal]lastPathComponent];
    }else if([tableColumn.identifier isEqual:@"2"]){
        result.textField.stringValue = [newDocument getOriginalSize];
        result.textField.alignment = NSRightTextAlignment;
    }
    if ([result.textField.stringValue isEqualTo:@"Missing File"]){
        [result setBackgroundStyle:NSBackgroundStyleDark];
        [result.textField setTextColor:[NSColor redColor]];
    }
    if ([result.textField.stringValue rangeOfString:@"K"].location != NSNotFound||[result.textField.stringValue isEqualTo:@"Blank Page"]) {
        [result.textField setTextColor:[NSColor blueColor]];
    }
    return result;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _whiteThreshold = 253;
    _documentArray = [[NSMutableArray alloc] initWithCapacity:10];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_scrollView setDocumentView:_tableView];
    // Insert code here to initialize your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}

- (IBAction)splitButton:(id)sender {
    [_progress startAnimation:self];
    //iterate through _documentArray, looking for blank files (low numbers), and create new folders after each one
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setTitle:@"Choose Folder To Save To"];
    [panel canCreateDirectories];
    NSInteger clicked = [panel runModal];
    //This runs if the ok button was clicked on the open panel.
    NSMutableArray *newFiles = [[NSMutableArray alloc]initWithCapacity:10];
    if (clicked == NSFileHandlingPanelOKButton) {
        NSLog(@"%@",[[panel URL]path]);
        int index = 0;
        [newFiles addObject:[[NSMutableArray alloc]initWithCapacity:10]];
        for(Document* doc in _documentArray){
            [[newFiles objectAtIndex:index]addObject:doc];
            NSString *sizeString = [doc getOriginalSize];
            if([sizeString isEqualTo:@"Blank Page"]){
                index++;
                [newFiles addObject:[[NSMutableArray alloc]initWithCapacity:10]];
            }
        }
        NSURL *newlocation = [panel URL];
        BOOL isDir;
        NSFileManager *fileManager= [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:[newlocation path] isDirectory:&isDir])
            if(![fileManager createDirectoryAtPath:[newlocation path] withIntermediateDirectories:YES attributes:nil error:NULL])
                NSLog(@"Error: Create folder failed %@", [newlocation path]);
        
        //newFiles is the mainFile
        for (NSMutableArray *folder in newFiles){
            NSString *folderName = [[[[[folder objectAtIndex:0]getOriginal]path]lastPathComponent]stringByDeletingPathExtension];
        
            NSString *folderPath = [[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", newlocation,folderName]]path];
            NSLog(@"%@",folderPath);
            NSFileManager *fileManager= [[NSFileManager alloc]init];
            BOOL isDir;
            if(![fileManager fileExistsAtPath:folderPath isDirectory:&isDir]){
                if(![fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL])
                    NSLog(@"Error: Create folder failed %@", folderPath);
            }else{
                NSLog(@"Error 2");
            }
            
            NSFileManager *manager = [NSFileManager defaultManager];
            for (Document* doc in folder){
                //make a toURL
                NSString *originalFile = [[[doc getOriginal]path]lastPathComponent];
                NSString *newFilePath = [NSString stringWithFormat:@"%@/%@",folderPath,originalFile];
                NSURL *newFileLocation = [NSURL fileURLWithPath:newFilePath];
//                NSLog(@"%@",newFileLocation);
                [manager moveItemAtURL:[doc getOriginal] toURL:newFileLocation error:nil ];
            }
        }
    }
    [_progress stopAnimation:self];

}
- (IBAction)changeThreshold:(id)sender {
    _thresholdText.stringValue = [NSString stringWithFormat:@"%li",(long)[sender integerValue]];
    _whiteThreshold = [sender integerValue];
    if ([sender integerValue]<240){
        _thresholdText.textColor = [NSColor redColor];
    }else if([sender integerValue]>254){
        _thresholdText.textColor = [NSColor redColor];
    }else{
        _thresholdText.textColor = [NSColor blackColor];
    }
}
- (IBAction)restartButton:(id)sender {
    _documentArray = [[NSMutableArray alloc]initWithCapacity:10];
    [_tableView reloadData];
    _whiteThreshold = 253;
    _thresholdText.stringValue = @"253 (Default)";
    _stepperValue.integerValue = 253;
}
- (IBAction)helpButton:(id)sender {
    _helpwindow = [[HelpWindow alloc]init];
}
- (IBAction)resort:(id)sender {
    _documentArray = [[NSMutableArray alloc]initWithArray:[Sorter mergeSort:_documentArray options:_sortChoice.indexOfSelectedItem]];
    [_tableView reloadData];
}
@end
