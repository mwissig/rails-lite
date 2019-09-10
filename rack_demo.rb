require 'rack'


# Just prints the text "hello there"
class RackApplication
  def self.call(env)
    ['200', {'Content-Type' => 'text/html'}, ["Hey there"]]
  end
end

# Prints hello and name in response to params
class SimpleApp
  def self.call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new

    name = req.params['name']
    res.write("Hello #{name}")
    res.finish
  end
end


#sets cookies

require 'json'

class CookieApp
  def self.call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new

    food = req.params['food']
    if food
      res.set_cookie(
        '_my_cookie_app',
              {
                path: '/',
                value: {food: food}.to_json
              }
            )
    else
      cookie = req.cookies['_my_cookie_app']
      cookie_val = JSON.parse(cookie)
      food = cookie_val['food']
      res.write("Your favorite food is #{food}")
    end
    res.finish
  end
end

# app without a class + redirect

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new

  if req.path.start_with?("/cage")
    res.status = 302
    res['Location'] = 'https://video-images.vice.com/articles/59526923de3dc55407e63849/lede/1498576162376-cage12.jpeg'
  else
    res.write("Nothing to see here")
  end
  res.finish
end

Rack::Server.start({
  app: app,
  Port: 3000
  })
