module ImageFetcher

	class ImageStats
		def initialize(path,content_type,content_length)
			@path = path
			@content_type = content_type
			@content_length = content_length

			case content_type
			when "image/gif"
				@format = "gif"
			when "image/jp2"
				@format = "jpeg2000"
			when "image/jpeg"
				@format = "jpg"
			when "image/vnd.ms-photo"
				@format = "jxr"
			when "image/png"
				@format = "png"
			when "image/webp"
				@format = "webp"
			else
				puts "Error: content-type not recognized"
			end
		end

		attr_accessor :path
		attr_accessor :content_type
		attr_accessor :content_length
		attr_accessor :format
	end

	class ImageFetcherAsBrowser
		def initialize(browser_to_fake,image_url)
			@browser = browser_to_fake
			@image_path = image_url
		end

		attr_accessor :image_url
		attr_accessor :image_local_path
		attr_accessor :browser

		def load_user_agents
			ua_file = File.open( ./userAgents.txt ,'r')

			#key: browser name with version
			#value: user agent string
			@user_agents = Hash.new("Unknown Browser - No user agent found for browser")

			File.foreach(ua_file).each_slice(1) do |line|
			browser=

		end

		def lookup_user_agent

		end

		def fetch
			aki_formats = [ "gif", "jp2", "jpg", "jxr", "png", "webp" ]

			@image_results = []

			aki_formats.each do |aki_format|
				
				query_suffix = "?aki_format=#{aki_format}"
				#TODO add output location, mkdir etc
				curl_cmd = "curl -s -w \"\n%{http_code}\n%{content_type}\n%{size_download}\n\" #{@image_path}#{query_suffix} -o /tmp/tmp"

				curl_output = `#{curl_cmd}`

				curl_output_array = curl_output.split

				is = ImageStats.new("/tmp/tmp", curl_output_array[1], curl_output_array[2])

				@image_results << is

				#puts "path: #{@image_results.last.path}"
				#puts "content_type: #{@image_results.last.content_type}"
				#puts "content_length: #{@image_results.last.content_length}"
				#puts "determined format: #{@image_results.last.format}"

			end
		end

		public
		def getSmallest(availableFormats)
			smallest_size=0
			smallest_format=nil
			@image_results.each do |image|
				if availableFormats.include? image.format
					if image.content_length.to_i < smallest_size or smallest_format == nil
						smallest_size = image.content_length.to_i
						smallest_format = image.format
					end
				end
			end
			return smallest_format
		end
			
	end

end
