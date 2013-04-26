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
    save_url = object.save_url.gsub("file://localhost", "")
    
    name = object.files.first
    input_video = File.basename(name.gsub(".", "_"))
    download_dir = "#{save_url}/#{input_video}".gsub("//", "/")
   
    bitrate = 768 * 1024
    
    gcdq = Dispatch::Queue.new('hls_encoding.gcd')
    gcdq.async {
      hls_encode = HLSEncoding.new
      hls_encode.bitrate = bitrate
      hls_encode.encoding_dir = download_dir
      hls_encode.input_video = object.files.first
      hls_encode.output_file = "segments/stream-%d.ts"
      hls_encode.on_start do
        @progressWindowController.performSelectorOnMainThread("encoding_start", withObject:nil, waitUntilDone:false)
      end
      hls_encode.on_complete do
        @progressWindowController.performSelectorOnMainThread("encoding_complete", withObject:nil, waitUntilDone:false)
      end
      hls_encode.on_pid do |pid|
        @progressWindowController.pid = pid
      end
      hls_encode.encode_task do |status|
        new_status = status.copy
        @progressWindowController.performSelectorOnMainThread("encoding_update:", withObject:new_status, waitUntilDone:false)
      end
    }
  end
end