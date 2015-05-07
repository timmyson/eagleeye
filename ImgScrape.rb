
=begin 
***	currently using the 'Mechanize' gem as an external 
	dependency to scrape a given URl.

	install command:
		-sudo gem install mechanize
		(may install dependencies that mechanize uses)
=end

require 'net/http'
require 'mechanize'


class ImgScrape

	def initialize()
		@mechanize = Mechanize.new
	end
	
	def get_images_from(url)
	
		#'load' the web page using mechanize
		page = @mechanize.get(url)

		numImagesOnPage = 0
		numImageTypes = 0
		extentions = Array.new(32)

		page.images.each do |img|
			numImagesOnPage += 1
		end

		images = Array.new(numImagesOnPage)

		inc = 0
		page.images.each do |img|
			if(extentions.count(img.extname)==0)
					extentions[numImageTypes] = img.extname
					numImageTypes += 1
			end
			images[inc] = img.to_s
			inc += 1
		end
		return images
	end
end

