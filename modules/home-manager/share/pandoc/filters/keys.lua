local logging = require 'logging'

function Span (elem)
  logging.temp('elem', elem)
  logging.temp('content', elem.content[1].text)
  return pandoc.Str(elem.content[1].text .. " ")
end
