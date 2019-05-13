require "json"
require "uri"
require "net/http"

def lambda_handler(event:, context:)
  data = JSON.parse(event["body"])
  locked = data["locked"]

  uri  = URI.parse(ENV["SLACK_WEBHOOK_URL"])
  params = { text: locked ? ":punch::lock:施錠しました:punch::lock:" : ":hand::unlock:開錠しました:hand::unlock:" }
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.start do
   request = Net::HTTP::Post.new(uri.path)
   request.set_form_data(payload: params.to_json)
   http.request(request)
  end

  { statusCode: 200, body: JSON.generate(data) }
end
