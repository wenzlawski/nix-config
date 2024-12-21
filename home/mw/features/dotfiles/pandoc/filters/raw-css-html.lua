function RawBlock(elem)
   if elem.format == "css" then
      elem.format = "html"
      elem.text = "<style>\n" .. elem.text .. "\n</style>"
   end
   return elem
end

