require 'bim'

bim = Bim.new()
temp1 = bim.get_image_formats("Firefox","35")
temp2 = bim.get_image_formats("Firefox","37")
temp3 = bim.get_image_formats("Firefox","38")
temp4 = bim.get_image_formats("Chrome", "41")
temp5 = bim.get_image_formats("Chrome", "42")
temp6 = bim.get_image_formats("internet explorer","7")
temp7 = bim.get_image_formats("internet explorer","10.1")

print temp1.to_s + "\n"
print temp2.to_s + "\n" 
print temp3.to_s + "\n" 
print temp4.to_s + "\n" 
print temp5.to_s + "\n" 
print temp6.to_s + "\n" 
print temp7.to_s + "\n" 
