require 'rubygems'
require 'stringio'
require 'fastercsv'
require 'icanhasaudio'
require 'rserve'

puts 'Converting MP3 file to WAV file ...'
reader = Audio::MPEG::Decoder.new
File.open('mrt_closing.mp3', 'rb') do |input|
  File.open('out.wav', 'wb')  do |output| 
    reader.decode(input, output)
  end
end

puts 'Creating CSV data from WAV file ...'
# FasterCSV.open('wavdata.csv', 'w') do |csv|
#   csv << %w(channel_1 channel_2, combined)
#   File.open('out.wav') do |file|
#     while !file.eof?
#       first_channel_data, second_channel_data = file.read(4).unpack('ss')
#       csv << [first_channel_data, second_channel_data,first_channel_data+second_channel_data]
#     end
#   end
# end

FasterCSV.open('wavdata2.csv', 'w') do |csv|
 csv << %w(ch1 ch2 combined)
  File.open('out.wav') do |file|
    while !file.eof?
      if file.read(4) == 'data'
        length = file.read(4).unpack('l').first
        wavedata = StringIO.new file.read(length)
        while !wavedata.eof? 
          ch1, ch2 = wavedata.read(4).unpack('ss')
          csv << [ch1, ch2,ch1+ch2]
        end
      end
    end
  end
end

script=<<-EOF
  png(file='/Users/sausheong/projects/wavform/mrtplot.png', height=800, width=600, res=72)
  par(mfrow=c(3,1),cex=1.1)
  wav_data <- read.csv(file='/Users/sausheong/projects/wavform/wavdata2.csv', header=TRUE)
  plot(wav_data$combined, type='n', main='Channel 1', xlab='Time', ylab='Frequency')
  lines(wav_data$ch1)
  plot(wav_data$combined, type='n', main='Channel 2', xlab='Time', ylab='Frequency')
  lines(wav_data$ch2)
  plot(wav_data$combined, type='n', main='Channel 1 + Channel 2', xlab='Time', ylab='Frequency')
  lines(wav_data$combined)
  dev.off()
EOF

puts 'Calling R to create the plot ...'
Rserve::Connection.new.eval(script)
puts 'Done!'