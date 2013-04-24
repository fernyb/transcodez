#
#  DropZoneView.rb
#  Transcodez
#
#  Created by fernyb on 1/16/13.
#  Copyright 2013 fernyb. All rights reserved.
#


class DropZoneView < NSView
  attr_accessor :dotted_color
  
  def awakeFromNib
    self.registerForDraggedTypes([NSFilenamesPboardType])
  end
  
  # - (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
  def draggingEntered(sender)
    NSLog("*** Dragging Entered")
    NSDragOperationNone
  end
  
  #- (NSDragOperation)draggingUpdated:(id < NSDraggingInfo >)sender
  def draggingUpdated(sender)
    if self.dotted_color.nil?
      self.dotted_color = NSColor.colorWithCalibratedRed(0.483, green:0.736, blue:0.266, alpha:1.000)
      self.setNeedsDisplay(true)
    end
    NSDragOperationLink
  end
  
  #- (void)draggingExited:(id < NSDraggingInfo >)sender
  def draggingExited(sender)
    self.dotted_color = nil
    self.setNeedsDisplay(true)
    NSLog("*** Dragging Exited")
  end
  
  # - (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
  def performDragOperation(sender)
    sourceDragMask = sender.draggingSourceOperationMask
    pboard = sender.draggingPasteboard
    files = []
    
    if pboard.types.containsObject(NSFilenamesPboardType)
      files = pboard.propertyListForType(NSFilenamesPboardType)
    end
    
    if sourceDragMask & NSDragOperationLink
      self.add_files(files)
    else
      #NSLog("** Add Data From Files")
    end
    
    self.dotted_color = nil
    self.setNeedsDisplay(true)
    true
  end
  
  def add_files(files)
    save_panel = NSOpenPanel.openPanel
    save_panel.setAllowedFileTypes(["ts"])
    save_panel.setDirectoryURL(NSURL.URLWithString("file://~/Desktop"))
    save_panel.setMessage("Choose location to save files")
    save_panel.setCanChooseDirectories(true)
    save_panel.setCanChooseFiles(false)
    save_panel.setResolvesAliases(true)
    save_panel.setAllowsMultipleSelection(false)
    save_panel.setCanCreateDirectories(true)
    save_panel.setPrompt("Select")
    @dropzoneview = self
    
    save_panel.beginSheetModalForWindow(self.window, completionHandler: lambda {|result|
      if result == NSFileHandlingPanelOKButton
        save_url = save_panel.directoryURL.absoluteString
        saveLocation = Struct.new(:save_url, :files).new(save_url, files)
                                        
        @dropzoneview.performSelector("didSelectSaveLocation:", withObject:saveLocation, afterDelay:1)
        NSLog("***** Save URL #{save_url}")
        NSLog("***** Filename: #{ files.join(',') }")
      else
        NSLog("*** Button False")
      end
    })
  end
  
  def didSelectSaveLocation(saveLocation)
    NSNotificationCenter.defaultCenter.postNotificationName("didSelectSaveLocation", object:saveLocation)
  end
  
  def drawRect(rect)
    super
    gradient = NSGradient.alloc.initWithStartingColor(NSColor.colorWithCalibratedWhite(0.890, alpha:1.0),
                                     endingColor:NSColor.colorWithCalibratedWhite(0.991, alpha:1.0))
    
    gradient.drawInRect(self.bounds, angle:90.0)
    
    path = NSBezierPath.bezierPathWithRoundedRect(NSInsetRect(self.bounds, 10, 10), xRadius:10.0, yRadius:10.0)
    path.setLineWidth(2.0)
    path.setLineDash([5.0, 2.0], count:2, phase:3.0)
    
    if self.dotted_color.nil?
      NSColor.grayColor.set
    else
      self.dotted_color.set
    end
    
    path.stroke
    drawRectText
  end
  
  def drawRectText
    centerRect = self.bounds
    centerRect.size.height = (centerRect.size.height / 2) - 16
    
    text.drawInRect(centerRect, withAttributes:{})
  end
  
  def text
    attrString = NSMutableAttributedString.alloc.initWithString("Drop Video Here")
    attrString.beginEditing
    if self.dotted_color.nil?
      attrString.addAttribute(NSForegroundColorAttributeName, value:NSColor.darkGrayColor, range:NSMakeRange(0, attrString.length))
    else
      attrString.addAttribute(NSForegroundColorAttributeName, value:self.dotted_color, range:NSMakeRange(0, attrString.length))
    end
    attrString.addAttribute(NSFontAttributeName, value:NSFont.fontWithName("Helvetica", size:14), range:NSMakeRange(0, attrString.length))
    attrString.addAttribute(NSFontAttributeName, value:NSFont.fontWithName("Helvetica-Bold", size:14), range:NSMakeRange(5, 5))
    
    style = NSMutableParagraphStyle.alloc.init;
    style.setAlignment(NSCenterTextAlignment);
    
    attrString.addAttributes({ NSParagraphStyleAttributeName => style }, range:NSMakeRange(0, attrString.length))
    attrString.endEditing
    attrString
  end
end