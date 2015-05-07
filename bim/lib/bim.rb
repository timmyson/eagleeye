class Bim
	def initialize()
		#bv is used as a shortform for 'Browser Versions'	
		bv_path = File.join(File.dirname(__FILE__),"BrowserVersions.txt")	
		bv_file = File.open( bv_path ,'r')
		
		# 	keys 	- String ("Browser with Versoin")
		# 	value 	- Array of Strings (accepted image formats) 
		@browser_formats = Hash.new("Unknown Browser - Browser Type not found")		
		
		# 	keys 	- String ("Browser with possible ranges of versions")
		# 	value   - Array of floats (versions that share image formats)
		@browsers_w_ranges = Hash.new("No versions below given version accepted")

		File.foreach(bv_file).each_slice(3) do |two_lines|
			hasMultipleValues = false 
	  		browser = two_lines[0].to_s.chomp.downcase.split(" ")
	  		if browser[browser.size - 1] == '+' 

	  			version = browser[browser.size - 2].to_f
	  			name = (browser.first browser.size - 2).join(" ")

	  			if @browsers_w_ranges.has_key?(name)
	  				@browsers_w_ranges[name] = @browsers_w_ranges[name] << version
	  			else
	  				@browsers_w_ranges[name] = [version]
	  			end

	  			browser[browser.size - 2] = version.to_s
	  			browser.delete('+')
	  			browser = browser.join(" ")

	  		else
	  			browser[browser.size - 1] = browser[browser.size - 1].to_f.to_s
	  			browser = browser.join(" ")
	  		end
	  		
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
		# return an array of strings of the supported image formats for 
		# a given browser and version, return an error string if cannot find one
	  	def get_image_formats(browser, version)
	  		key = ((browser.to_s.strip) + " " + (version.to_f.to_s.strip)).downcase
	  		if @browser_formats.has_key?(key)	  			
		  		return @browser_formats[key]
		  	elsif @browsers_w_ranges.has_key?(browser.to_s.strip.downcase)
		  		desired_version = version.to_f
		  		possible_versions = @browsers_w_ranges[browser.to_s.strip.downcase]
		  		latest_version = -1;
		  		possible_versions.each do |v|
		  			if (v >= latest_version) && (v <= desired_version)
		  				latest_version = v
		  			end
		  		end
		  		if latest_version == -1
		  			return "Not in Database(Error - no known supported version for "+ 
		  					browser.to_s  + "(version " + version.to_s + "))"
		  		else
		  			desired_key = browser.to_s.strip.downcase + " " + latest_version.to_s
		  			return @browser_formats[desired_key]
		  		end
		  	end
		  	return "Not in Database(Error - no known browser: " + browser.to_s + " " + version.to_f.to_s + ")"
	  	end
end

