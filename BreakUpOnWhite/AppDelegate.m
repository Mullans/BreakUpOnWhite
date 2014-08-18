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
    [panel setTitle:@"Choose jpg folder"];
    NSArray  *fileTypes = [NSArray arrayWithObjects:@"jpg",nil];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:fileTypes];
    
    
    NSInteger clicked = [panel runModal];
    //This runs if the ok button was clicked on the open panel.
    if (clicked == NSFileHandlingPanelOKButton) {
        
        //This section sets and resizes the label to reflect the users choice.
        [_buttonLabel1  setStringValue:[[panel URL]path]];
        [_buttonLabel1 sizeToFit];
        [_buttonLabel1 setFrameOrigin:CGPointMake(self.window.frame.size.width*.25-_buttonLabel1.frame.size.width/2, _buttonLabel1.frame.origin.y)];
        
        //This gets all of the files from the selected directory, and skips hidden files.
        NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[panel URL] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        for(NSURL* item in dirs){
            //check to see if there is a document of the same name in original
            BOOL sentinel = YES;
            if (![[item pathExtension] isEqual:@"jpg"]){
                continue;
            }
            for(Document *doc in _documentArray){
                @try{
                    if([[[item lastPathComponent]stringByDeletingPathExtension] isEqualToString:[[[doc getCopy]lastPathComponent]stringByDeletingPathExtension]]){
                        [doc setOriginal:item];
                        sentinel = NO;
                        break;
                    }
//                    }else if([[item path] isEqualToString:[[doc getCopy]path] ]){
//                        //This section prevents the same file from being uploaded multiple times
//                        //This does not mean that files of the same name, but in a different name will be excluded though.
//                        sentinel = NO;
                }
                @catch(NSException *exception){
                    NSLog(@"\n:::%@\n:::::%@",[doc getCopy],item);
                    
                    NSLog(@"Error 1");
                }
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
                Document *newDocument = [[Document alloc]initWithOriginal:item];
                [_documentArray addObject:newDocument];
            }
        }
    }
    _jpgCount.stringValue = [NSString stringWithFormat:@"%lu Images",(unsigned long)[_documentArray count]];
    _documentArray = [[NSMutableArray alloc]initWithArray:[Sorter mergeSort:_documentArray options:_sortChoice.indexOfSelectedItem]];
    [_tableView reloadData];
}
- (IBAction)loadingButton2:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setTitle:@"Choose tif folder"];
    NSArray  *fileTypes = [NSArray arrayWithObjects:@"tif",nil];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:fileTypes];
    
    
    NSInteger clicked = [panel runModal];
    //This runs if the ok button was clicked on the open panel.
    if (clicked == NSFileHandlingPanelOKButton) {
        
        //This section sets and resizes the label to reflect the users choice.
        [_buttonLabel2  setStringValue:[[panel URL]path]];
        [_buttonLabel2 sizeToFit];
        [_buttonLabel2 setFrameOrigin:CGPointMake(self.window.frame.size.width*.75-_buttonLabel2.frame.size.width/2, _buttonLabel2.frame.origin.y)];
        
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
                    if([[[item lastPathComponent]stringByDeletingPathExtension] isEqualToString:[[[doc getOriginal]lastPathComponent]stringByDeletingPathExtension]]){
                        [doc setCopy:item];
                        sentinel = NO;
                        break;
                    }
                    //                    }else if([[item path] isEqualToString:[[doc getCopy]path] ]){
                    //                        //This section prevents the same file from being uploaded multiple times
                    //                        //This does not mean that files of the same name, but in a different name will be excluded though.
                    //                        sentinel = NO;
                }
                @catch(NSException *exception){
                    NSLog(@"\n:::%@\n:::::%@",[doc getOriginal],item);
                    
                    NSLog(@"Error 1");
                }
                @try{
                    if([[item path] isEqualToString:[[doc getCopy]path]]){
                        sentinel = NO;
                        break;
                    }
                }@catch(NSException *exception){
                    NSLog(@"Error 2");
                }
            }
            if (sentinel){
                Document *newDocument = [[Document alloc]initWithCopy:item];
                [_documentArray addObject:newDocument];
            }
        }
    }
    _documentArray = [[NSMutableArray alloc]initWithArray:[Sorter mergeSort:_documentArray options:_sortChoice.indexOfSelectedItem]];
    [_tableView reloadData];
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
    }else if([tableColumn.identifier isEqual:@"3"]){
        result.textField.stringValue = [[newDocument getCopy]lastPathComponent];
    }else if([tableColumn.identifier isEqual:@"2"]){
        result.textField.stringValue = [newDocument getOriginalSize];
        result.textField.alignment = NSRightTextAlignment;
    }else if([tableColumn.identifier isEqual:@"4"]){
        result.textField.stringValue = [newDocument getCopySize];
//        NSLog(@"%@",result.textField.stringValue);
        result.textField.alignment = NSRightTextAlignment;
    }
    if ([result.textField.stringValue isEqualTo:@"Missing File"]){
        [result setBackgroundStyle:NSBackgroundStyleDark];
        [result.textField setTextColor:[NSColor redColor]];
    }
    if ([result.textField.stringValue rangeOfString:@"K"].location != NSNotFound) {
        [result.textField setTextColor:[NSColor blueColor]];
    }
    return result;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
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
    //iterate through _documentArray, looking for blank files (low numbers), and create new folders after each one
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setTitle:@"Choose Folder To Save To"];
    [panel canCreateDirectories];
    NSInteger clicked = [panel runModal];
    //This runs if the ok button was clicked on the open panel.
    if (clicked == NSFileHandlingPanelOKButton) {
        NSLog(@"%@",[[panel URL]path]);
        for(Document* doc in _documentArray){
            NSString *sizeString = [doc getOriginalSize];
            if([sizeString isEqualTo:@"Blank Page"]){
                NSLog(@"Blank Page");
            }
        }
    }
}
@end
