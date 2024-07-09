require 'net/http'
require 'uri'
require 'json'

module Vandelay
  module Integrations
    module Vendors
      class Base
        attr_reader :base_url, :auth_url, :auth_token, :records_url

        def initialize
          @base_url    = nil
          @auth_url    = nil
          @records_url = nil

          @auth_token  = nil
        end

        def authenticate
          get(auth_url) do |_, _, body|
            @auth_token = body["token"]
          end
        end

        def all
          authenticate if auth_token.nil?
          get(records_url) do |_, _, body|
            body.map { |r| record_mapper(r) }
          end
        end

        def find_by(id: nil)
          record_url = [records_url, '/', id].join

          authenticate if auth_token.nil?
          get(record_url) do |_, _, body|
            body
            return {} if body.empty?
            record_mapper(body)
          end
        end

      private
        def get(url, &block)
          url = URI.parse(url)

          begin
            http = Net::HTTP.new(url.host, url.port)

            req = Net::HTTP::Get.new(url.request_uri)
            req['Authorization'] = "Bearer #{auth_token}" if auth_token

            res = http.request(req)
            body = JSON.parse(res.body)

            yield(req, res, body)

          rescue StandardError => e
            "Authentication failed: #{e.message}"
          end
        end

        def record_mapper(record)
          raise NotImplementedError
        end
      end
    end
  end
end