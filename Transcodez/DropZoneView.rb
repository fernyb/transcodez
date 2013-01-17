#
#  DropZoneView.rb
#  Transcodez
#
#  Created by fernyb on 1/16/13.
#  Copyright 2013 fernyb. All rights reserved.
#


class DropZoneView < NSView
  
  def drawRect(rect)
    super
    gradient = NSGradient.alloc.initWithStartingColor(NSColor.colorWithCalibratedWhite(0.890, alpha:1.0),
                                     endingColor:NSColor.colorWithCalibratedWhite(0.991, alpha:1.0))
    
    gradient.drawInRect(self.bounds, angle:90.0)
    
    path = NSBezierPath.bezierPathWithRoundedRect(NSInsetRect(self.bounds, 10, 10), xRadius:10.0, yRadius:10.0)
    path.setLineWidth(2.0)
    path.setLineDash([5.0, 2.0], count:2, phase:3.0)
    
    NSColor.grayColor.set
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
    attrString.addAttribute(NSForegroundColorAttributeName, value:NSColor.darkGrayColor, range:NSMakeRange(0, attrString.length))
    attrString.addAttribute(NSFontAttributeName, value:NSFont.fontWithName("Helvetica", size:14), range:NSMakeRange(0, attrString.length))
    attrString.addAttribute(NSFontAttributeName, value:NSFont.fontWithName("Helvetica-Bold", size:14), range:NSMakeRange(5, 5))
    
    style = NSMutableParagraphStyle.alloc.init;
    style.setAlignment(NSCenterTextAlignment);
    
    attrString.addAttributes({ NSParagraphStyleAttributeName => style }, range:NSMakeRange(0, attrString.length))
    attrString.endEditing
    attrString
  end
end