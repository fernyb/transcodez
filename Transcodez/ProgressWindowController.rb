#
#  ProgressWindowController.rb
#  Transcodez
#
#  Created by fernyb on 4/24/13.
#  Copyright 2013 fernyb. All rights reserved.
#


class ProgressWindowController < NSWindowController
  attr_accessor :progressBar
  attr_accessor :progressLabel
  attr_accessor :pid
  
  def init
    self.initWithWindowNibName("Progress", owner:self)
    self
  end
  
  def awakeFromNib
    self.progressLabel.setStringValue("")
  end

  def initWithWindow(aWindow)
    super(aWindow)
  end
  
  def windowDidLoad
    super
    NSLog("Progress Window Did Load")
  end
  
  def encoding_start
    @progressLabel.setStringValue("")
    @progressBar.setIndeterminate(false)
    @progressBar.startAnimation(self)
    @progressBar.setMaxValue(100)
    @progressBar.setMinValue(0)
    @progressBar.setDoubleValue(0)
    @progressBar.displayIfNeeded
  end
  
  def encoding_complete
    NSSound.soundNamed("Glass").play
    self.window.orderOut(nil)
  end
  
  def encoding_update(status)
    @progressBar.setDoubleValue(status.percent.to_f)
    @progressBar.displayIfNeeded
    @progressLabel.setStringValue("Time: #{sprintf('%.2f', status.time)} / Duration: #{sprintf('%.2f', status.duration)}")
    @progressLabel.displayIfNeeded
    
    #$stderr.print "\r Percent: #{status.percent}%, Progress: #{status.progress}, Time: #{status.time}, Duration: #{status.duration} "
  end
  
  def btnCloseWindow(sender)
    if @pid
      $stdout.print "********** Stop Current Pid: #{@pid} \n"
      `kill -9 #{@pid}`
    end
    self.window.orderOut(nil)
  end
end