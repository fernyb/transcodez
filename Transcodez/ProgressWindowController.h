//
//  ProgressWindowController.h
//  Transcodez
//
//  Created by fernyb on 4/24/13.
//  Copyright (c) 2013 fernyb. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProgressWindowController : NSWindowController
{
  IBOutlet NSProgressIndicator * progressBar;
  IBOutlet NSTextField * progressLabel;
}

- (IBAction)btnCloseWindow:(id)sender;

@end
