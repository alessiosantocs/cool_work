class CsvFileController < ApplicationController

 #  def genFiles
  	#@output = system("/usr/bin/python2.6 "+ Rails.root.to_s.chomp + "/public/cvs/indexHealth20.py")
 	#logger.info(@output)
 #   logger.info(Rails.root.to_s)
 #   path = (Rails.root.to_s.chomp) + "/public/csv/indexHealth20.py"
 #   logger.info(path)
 #	@output = `/usr/bin/python2.6  #{path}`
 #
 #	logger.info(@output)
 #
 # end 

  def readfile
	Companies.all 
    logger.info(Rails.root.to_s)
    path = (Rails.root.to_s.chomp) + "/public/csv/*.csv"
    logger.info(path)
	@output = `ls  #{path}`
	logger.info(@output)
	@fileList = @output.split("\n")	
	logger.info(@fileList)
  end 

 
  def download
    send_file params[:filename], :type=>"application/file" 
  end


end
