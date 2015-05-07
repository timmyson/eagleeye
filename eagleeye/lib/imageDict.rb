module ImageDictionaryModule

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
				puts "Error: content-type not recognized: " + content_type 
			end
		end

		attr_accessor :path
		attr_accessor :content_type
		attr_accessor :content_length
		attr_accessor :format
	end

	class ImageDictionary
		def initialize(image_path)
			@image_path = image_path
			fetch
		end

		attr_accessor :image_path


		def fetch
			aki_formats = [ "gif", "jp2", "jpg", "jxr", "png", "webp" ]

			@image_results = []

			aki_formats.each do |aki_format|
				
				query_suffix = "?aki_format=#{aki_format}"
				#TODO add output location, mkdir etc

				curl_cmd = "curl -s -w \"\n%{http_code}\n%{content_type}\n%{size_download}\n\" #{@image_path}#{query_suffix} -o /tmp/tmp"
				# puts curl_cmd 
				curl_output = `#{curl_cmd}`
				


				curl_output_array = curl_output.split

				

				if curl_output_array[0].chomp == '200' or curl_output_array[0].chomp == '304'
					#puts image_path 
					#puts curl_output 
					is = ImageStats.new("/tmp/tmp", curl_output_array[1], curl_output_array[2])
				else
					#puts image_path 
					#puts curl_output 
					puts "    Unexpected Http return code: " + curl_output_array[0] + " for image :" 
					next 
				end

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
