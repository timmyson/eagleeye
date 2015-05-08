
require_relative "./lib/imageDict.rb"

include ImageDictionaryModule

require 'bim'
require "../ImgScrape.rb"
require "./lib/UserAgent"


urls = Array.new
browsers = Array.new
user_agents = Array.new 
urls_to_images = Hash.new("Unknown URL")



File.open("./lib/userAgents.txt").each_line do |ua|
	
	user_agent = UserAgentType.new(ua)
	user_agents << user_agent 
	version = user_agent.browser_version.to_s
	
	if version.count(".") > 1 
		version = version[0,version.index('.',version.index('.') + 1)]
	end
	browser = user_agent.browser.to_s

	if browser[0] == '"'
		browser[0] = ""
	end

	browsers << [browser,version]
end

File.open("./urls.txt").each_line do |url|
	urls = urls << url.strip 
end

#run ImgScrape to scrape URL for images
#

img_scraper = ImgScrape.new 

puts "\nScraping webpages for images..."

urls.each do |url|
	urls_to_images[url] = img_scraper.get_images_from(url)
end

# 'urls_to_images' is now populated with a hash map mapping a string(given url) 
#to an array of strings(lings to all images on a given page)

#fetch various output formats (
#

bim = Bim.new
#chrome_latest_formats = bim.get_image_formats('chrome', '42.02311135') 

#fetch image as requested by each browser

#

#find size and format we think the best should be

# eif is short for expected image format


itr = 0 
 
urls_to_images.each do |url, imgs|
	browsers.each do |browser|
		puts "\n----------------------------------"
		puts "Showing image formats for :" + url.to_s 
		puts "Browser: " + browser[0] + " Version: " + browser[1]
		puts "----------------------------------"
	

		imgs.each do |img_url|

			user_agent_ret_val = user_agents[itr].fetch_img_w_ua(img_url)

			fetched_image = ImageDictionary.new(img_url).getSmallest(bim.get_image_formats(browser[0], browser[1]))	

			puts "----------------------------------------------------------------------------"
			if fetched_image != nil 
				puts "    "+fetched_image.to_s + " -- for " + img_url
				puts "    retrieved from user agent request : " + user_agent_ret_val[1]
			else
				puts "    NIL smallest image"
				puts "    retrieved from user agent request : " + user_agent_ret_val[1]
			end	
			puts "----------------------------------------------------------------------------"
		
		end
		itr += 1
	end
end
 



#compare file size and format between the two  (expected smallest file zize, file size returned by user agent) , raise error on any discrepency
#this should be done in the above loop to my undersanding 




















