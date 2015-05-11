
require_relative "./lib/imageDict.rb"

include ImageDictionaryModule

require 'bim'
require "./lib/ImgScrape.rb"
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

File.open("./lib/urls.txt").each_line do |url|
	urls = urls << url.strip 
end

img_scraper = ImgScrape.new 

puts "\nScraping webpages for images..."

urls.each do |url|
	urls_to_images[url] = img_scraper.get_images_from(url)
end

bim = Bim.new

fname = "output.txt"
mismatch_log = File.open(fname,'w')
total_mismatches = 0
itr = 0 
print "Comparing image formats... " 

browsers_done = 0
total_browsers = browsers.size.to_f 
urls_to_images.each do |url, imgs|
	browsers.each do |browser|
		tmp = browsers_done.to_f/total_browsers.to_f*100.0 
		print "\rComparing image formats... #{tmp}%" 
		matches = 0
		mismatches = 0 
		errors = 0
		imgs.each do |img_url|

			user_agent_ret_val = user_agents[itr].fetch_img_w_ua(img_url)
			possible_formats = bim.get_image_formats(browser[0], browser[1])
			img_dict = ImageDictionary.new(img_url)
			fetched_image = img_dict.getSmallest(possible_formats)
			possible_images = img_dict.getAll(possible_formats)
			if fetched_image[0] != nil 
				if fetched_image[0].to_s == user_agent_ret_val[1] 
					matches += 1 
				else
					
					mismatch_log.puts("Showing mismatch for image: "+img_url)
					mismatch_log.puts("    Browser: " + browser[0] + " "+ browser[1])
					mismatch_log.puts("    User Agent: " + user_agents[itr].user_agent)
					mismatch_log.print("    Pool of possible Formats: ")
					mismatch_log.print(possible_formats)
					mismatch_log.print("\n    Pool of possible images: ")
					mismatch_log.print(possible_images)
					mismatch_log.puts("\n    Format expected: "+fetched_image[0])
					mismatch_log.puts("               size: "+fetched_image[1].to_s)
					mismatch_log.puts("    Format returned: "+user_agent_ret_val[1])
					mismatch_log.puts("               size: "+user_agent_ret_val[2])
					mismatch_log.puts("------------------------------------------------------------------------------------------------------------------\n")

					mismatches += 1
					total_mismatches += 1
				end
			else
				errors += 1
			end	
		end
		itr += 1
	end
end

mismatch_log.puts("\nTOTAL MISMATCHES: "+total_mismatches.to_s)
mismatch_log.close() 
puts "\nDone."




















