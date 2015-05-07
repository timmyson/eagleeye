
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

#fetch various output formats

#

#fetch image as requested by each browser
#

#find size and format we think the best should be
#

#compare file size and format between the two, raise error on any discrepency
