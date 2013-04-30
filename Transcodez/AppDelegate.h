//
//  AppDelegate.h
//  Transcodez
//
//  Created by fernyb on 4/29/13.
//  Copyright (c) 2013 fernyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgressWindowController.h"

@interface AppDelegate : NSObject
{
  IBOutlet NSWindow * window;
  IBOutlet ProgressWindowController * progressWindowController;
  IBOutlet NSPopUpButton * bitrateSelectionButton;
}
@end
