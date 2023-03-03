require 'json'
require 'net/http'
require 'uri'

def lambda_handler(event:, context:)
    payload = JSON.parse(event["body"])
    type = payload["Type"]
    if type == "SpamNotification"
        email = payload["Email"]
        token = ENV["slack_webhook_token"]
        
        uri = URI.parse("https://hooks.slack.com/services/#{token}")
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request.body = "{'text':'Spam Alert detected from email - #{email}'}"

        req_options = {
          use_ssl: uri.scheme == "https",
        }

       	Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        return "spam"
    end
    "not spam"
end

