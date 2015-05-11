require 'useragent'

class UserAgentType 

	def initialize(userAgent)		
		ua_parse = UserAgent.parse(userAgent)
		@user_agent = userAgent  
		@browser = ua_parse.browser
		@browser_version = ua_parse.version
	end

	def fetch_img_w_ua(img_path)

		curl_cmd = "curl -s -w \"\n%{http_code}\n%{content_type}\n%{size_download}\n\" #{img_path} -o /tmp/tmp -A #{@user_agent}"
		curl_output = `#{curl_cmd}`
		curl_output = curl_output.split

		if curl_output[0].chomp == '200' or curl_output[0].chomp == '304'
			curl_output[1]["image/"] = ""
			return curl_output 
		else
			return "Unexpected Http return code: " + curl_output[0] + " for image :" + img_path			
		end

	end

	attr_accessor :browser
	attr_accessor :browser_version
	attr_accessor :user_agent
end
