#
#  AppDelegate.rb
#  Transcodez
#
#  Created by fernyb on 1/11/13.
#  Copyright 2013 fernyb. All rights reserved.
#

class AppDelegate
  attr_accessor :window
  attr_accessor :progressWindowController
  
  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
  end
  
  def awakeFromNib
    NSNotificationCenter.defaultCenter.addObserver(self, selector:"didDropFiles:", name:"didSelectSaveLocation", object:nil)
  end
  
  def didDropFiles(aNotification)
    @progressWindowController ||= ProgressWindowController.alloc.init
    NSApplication.sharedApplication.beginSheet(@progressWindowController.window,
                                               modalForWindow: self.window,
                                               modalDelegate: self,
                                               didEndSelector: nil,
                                               contextInfo: nil)
    self.start_encoder(aNotification.object)
  end
  
  def start_encoder(object)
    NSLog(object.inspect)
  end
end