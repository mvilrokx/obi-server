$:<<::File.dirname(__FILE__)

require 'obi_server'

map "/" do
  run ObiServer
end