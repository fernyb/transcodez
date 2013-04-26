#
#  HLSEncoding.rb
#  Transcodez
#
#  Created by fernyb on 4/25/13.
#  Copyright 2013 fernyb. All rights reserved.
#

class HLSEncoding < EncodingBase
  def encode &block
    $stdout.puts "**** Encoding Dir: #{self.encoding_dir}"
    $stdout.puts "**** Input Video:  #{self.input_video}"
    $stdout.puts "**** Output Video: #{self.output_file}\n"
    
    `mkdir -p "#{self.encoding_dir}/segments"`
    super &block
  end
  
  def encode_task &block
    $stdout.puts "**** Encoding Dir: #{self.encoding_dir}"
    $stdout.puts "**** Input Video:  #{self.input_video}"
    $stdout.puts "**** Output Video: #{self.output_file}\n"
    
    `mkdir -p "#{self.encoding_dir}/segments"`
    super &block
  end
  
  def ffmpeg_command
    command = "cd \"#{self.encoding_dir}\"; #{self.ffmpeg_bin} -i \"#{self.input_video}\" -re -g 250 -keyint_min 25 -bf 0 -me_range 16 \
    -sc_threshold 40 -cmp 256 -coder 0 -trellis 0 -subq 6 -refs 5 -r 25 -c:a libfaac -ab:a 256k \
    -async 1 -ac:a 2 -c:v libx264 -profile:v baseline -s:v 640x360 -b:v #{self.bitrate} -aspect:v 16:9 -map 0 -ar 44100 \
    -vbsf h264_mp4toannexb -flags -global_header \
    -f segment -segment_time 10 \
    -segment_list_type flat -segment_list_type m3u8 -segment_list playlist.m3u8 \
    -segment_format mpegts \"#{self.output_file}\""
    command
  end
  
  def ffmpeg_command_list
    ["-i",
    "#{self.input_video}",
    "-re",
    "-g",
    "250",
    "-keyint_min",
    "25",
    "-bf",
    "0",
    "-me_range",
    "16",
    "-sc_threshold",
    "40",
    "-cmp",
    "256",
    "-coder",
    "0",
    "-trellis",
    "0",
    "-subq",
    "6",
    "-refs",
    "5",
    "-r",
    "25",
    "-c:a",
    "libfaac",
    "-ab:a",
    "256k",
    "-async",
    "1",
    "-ac:a",
    "2",
    "-c:v",
    "libx264",
    "-profile:v",
    "baseline",
    "-s:v",
    "640x360",
    "-b:v",
    "#{self.bitrate}",
    "-aspect:v",
    "16:9",
    "-map",
    "0",
    "-ar",
    "44100",
    "-vbsf",
    "h264_mp4toannexb",
    "-flags",
    "-global_header",
    "-f",
    "segment",
    "-segment_time",
    "10",
    "-segment_list_type",
    "flat",
    "-segment_list_type",
    "m3u8",
    "-segment_list",
    "playlist.m3u8",
    "-segment_format",
    "mpegts",
    "#{self.output_file}"
    ]
  end
end