
require_relative "./lib/imageDict.rb"

include ImageDictionaryModule

require 'bim'
require "../ImgScrape.rb"

#read list of URL's
urls = Array.new
File.open("./urls.txt").each_line do |url|
	urls = urls << url.to_s.strip 
end

#run ImgScrape to scrape URL for images
#

urls_images = Hash.new ("Unknown URL")
img_scraper = ImgScrape.new 

urls.each do |url|
	urls_images[url] = img_scraper.get_images_from(url)
end

# 'urls_images' is now populated with a hash map mapping a string(given url) 
#to an array of strings(lings to all images on a given page)

#fetch various output formats (
#

bim = Bim.new
#chrome_latest_formats = bim.get_image_formats('chrome', '42.02311135') 

#fetch image as requested by each browser

#

#find size and format we think the best should be
urls_images.each do |url, imgs|
	puts "\n----------------------------------"
	puts "Showing image formats for :" + url.to_s
	puts "----------------------------------"
	imgs.each do |img_url|
		fetched_image = ImageDictionary.new(img_url).getSmallest(bim.get_image_formats('chrome', '30.0'))	
		if fetched_image != nil 
			puts "    "+fetched_image.to_s + " -- for " + img_url
		else
			puts "NIL smallest image"
		end		
	end
end
#

#compare file size and format between the two, raise error on any discrepency
