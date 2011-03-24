# require 'rubygems'
# require 'stringio'
# require 'fastercsv'
# FasterCSV.open('wavdata2.csv', 'w') do |csv|
#  csv << %w(ch1 ch2 combined)


  File.open('out.wav') do |file|
    while !file.eof?
      if file.read(4) == 'data'
        puts file.pos
        p file.read(4).unpack('l')
        # length = file.read(4).unpack('s').first
        # wavedata = StringIO.new file.read(length)
        # while !wavedata.eof? 
        #   ch1, ch2 = wavedata.read(4).unpack('ss')
        #   csv << [ch1, ch2,ch1+ch2]
        # end
      end
    end
  end
# end