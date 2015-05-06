
class Bim
	#bv is used as a shortform for 'Browser Versions'	
	def initialize()
		bv_path = File.join(File.dirname(__FILE__),"BrowserVersions.txt")	
		bv_file = File.open( bv_path ,'r')

		@browser_formats = Hash.new("Unknown Browser - Browser Type not found")
	  	File.foreach(bv_file).each_slice(2) do |two_lines|
	  		browser = two_lines[0].to_s.chomp.downcase
	  		supported_formats = two_lines[1].split(",")

	  		itr = 0
	  		supported_formats.each do |format|
				supported_formats[itr] = format.strip.chomp.downcase  		
				itr += 1
	  		end
	  		@browser_formats[browser] = supported_formats
	  	end 

	end


	public
		# return an array of strings of the supported image 
		# formats for a given browser and version 
	  	def getImageFormats(browser, version)
	  		browser = browser.to_s + " " + version.to_s
	  		browser = browser.downcase
	  		return @browser_formats[browser]
	  	end
end

