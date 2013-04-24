#
#  ProgressWindowController.rb
#  Transcodez
#
#  Created by fernyb on 4/24/13.
#  Copyright 2013 fernyb. All rights reserved.
#


class ProgressWindowController < NSWindowController
  
  def init
    self.initWithWindowNibName("Progress", owner:self)
    self
  end
  
  def initWithWindow(aWindow)
    super(aWindow)
  end
  
  def windowDidLoad
    super
    NSLog("Progress Window Did Load")
  end
  
  def btnCloseWindow(sender)
    self.window.orderOut(nil)
  end
end