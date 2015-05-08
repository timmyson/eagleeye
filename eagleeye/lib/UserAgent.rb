require 'useragent'

class UserAgentType 

	def initialize(userAgent)		
		@userAgent = userAgent
		ua_parse = UserAgent.parse(userAgent)
		@browser = ua_parse.browser
		@browser_version = ua_parse.version
	end

	def fetch_img_w_ua(img_url)
		#ToDo - Write the fucntion to make the user agent request the url (an image)

		#ToDo - Return the image format that was given from the UA 
		
	end

	attr_accessor :browser
	attr_accessor :browser_version
end
