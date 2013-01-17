#
#  AppDelegate.rb
#  Transcodez
#
#  Created by fernyb on 1/11/13.
#  Copyright 2013 fernyb. All rights reserved.
#

class AppDelegate
  attr_accessor :window
  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
    self.window.setContentBorderThickness(24.0, forEdge:NSMinYEdge)
  end
end

