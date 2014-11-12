require 'json'

class BackendMock
  def call(env)
    headers = {}
    env.each_pair do |k, v|
      if /^HTTP_(.+)$/ =~ k
        headers[$1] = v
      end
    end

    [200, {'Content-Type' => 'application/json'}, [headers.to_json]]
  end
end

run BackendMock.new
