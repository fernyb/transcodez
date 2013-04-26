#
#  EncodingBase.rb
#  Transcodez
#
#  Created by fernyb on 4/25/13.
#  Copyright 2013 fernyb. All rights reserved.
#

require 'open3'

class EncodingBase
  attr_accessor :encoding_dir
  attr_accessor :ffmpeg_bin
  attr_accessor :input_video
  attr_accessor :output_file
  attr_accessor :duration
  attr_accessor :bitrate
  attr_accessor :on_start_block
  attr_accessor :on_complete_block
  attr_accessor :on_pid_start
  attr_accessor :encode_task_block
  
  def initialize
    self.ffmpeg_bin = "/usr/local/ffmpeg-1.0/bin/ffmpeg"
    NSNotificationCenter.defaultCenter.addObserver(self, selector:"taskReadCompletionNotification:", name:"NSFileHandleReadCompletionNotification", object:nil)
  end
  
  def get_duration
    output = Open3.popen3("cd #{self.encoding_dir}; #{self.ffmpeg_bin} -i #{self.input_video}") {|stdin, stdout, stderr|
      stderr.read
    }
    output[/Duration:\s+(\d{2}):(\d{2}):(\d{2}\.\d{2})/]
    self.duration = ($1.to_i * 60 * 60) + ($2.to_i * 60) + $3.to_f
  end
  
  def on_start &block
    @on_start_block = block
  end
  
  def on_complete &block
    @on_complete_block = block
  end
  
  def on_pid &block
    @on_pid_start = block
  end
  
  def encode &block
    get_duration
    encoding_time = EncodingTime.new
    encoding_time.duration = self.duration
    
    command = "#{self.ffmpeg_command} 2>&1"
    
    $stdout.puts "\n\n#{command}\n\n"
    
    if self.on_start_block
      self.on_start_block.call
    end
    
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      stdout.each("r") do |line|
        $stdout.puts "******* Wait Thr: #{ wait_thr.inspect }"
        
        if line.include?("time=")
          time = if line =~ /time=(\d+):(\d+):(\d+\.?\d+)/ then
            ($1.to_i * 3600) + ($2.to_i * 60) + $3.to_f
          else
            0.0
          end
        
          begin
            progress = time / @duration
            percent = (progress * 100.0).floor
            encoding_time.percent  = percent
            encoding_time.progress = progress
            encoding_time.time     = time
            yield encoding_time
          rescue FloatDomainError => e
            $stdout.puts "*** Float Domain Error: #{e.inspect}"
          end # end begin
        end # end if line
      end # end stdout
    end # end Open3
  
    if self.on_complete_block
      self.on_complete_block.call
    end
  end

  def encode_task &block
    self.encode_task_block = block
    get_duration
    @encoding_time = EncodingTime.new
    @encoding_time.duration = self.duration
    
    if self.on_start_block
      self.on_start_block.call
    end
    
    task = NSTask.new
    task.setCurrentDirectoryPath(self.encoding_dir)
    task.setLaunchPath(self.ffmpeg_bin)
    task.setArguments(self.ffmpeg_command_list)
    
    pipe = NSPipe.pipe
    task.setStandardOutput(pipe)
    task.setStandardError(pipe)
    
    file = pipe.fileHandleForReading
    file.readInBackgroundAndNotify
    task.launch
    task.waitUntilExit
    
    if self.on_complete_block
      self.on_complete_block.call
    end
  end

  def taskReadCompletionNotification(aNotification)
    data = aNotification.userInfo.objectForKey("NSFileHandleNotificationDataItem")
    stdout = NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding)
    
    #$stdout.puts stdout
    
    stdout.split("\r").each do |line|
      if line.include?("time=")
        time = if line =~ /time=(\d+):(\d+):(\d+\.?\d+)/ then
          ($1.to_i * 3600) + ($2.to_i * 60) + $3.to_f
        else
          0.0
        end
     
      begin
        progress = time / @duration
        percent = (progress * 100.0).floor
        @encoding_time.percent  = percent
        @encoding_time.progress = progress
        @encoding_time.time     = time
        self.encode_task_block.call(@encoding_time)
        rescue FloatDomainError => e
        $stdout.puts "*** Float Domain Error: #{e.inspect}"
        end # end begin
      end # end if line
    end # end stdout

    aNotification.object.readInBackgroundAndNotify

    #if self.encode_task_block
    #  self.encode_task_block.call
    #end
  end
                      
  def ffmpeg_command_list
  end
                      
  def ffmpeg_command
  end
end