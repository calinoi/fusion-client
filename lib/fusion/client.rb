require 'fusion/client/version'
require 'json'

module Fusion
  class Client
    attr_accessor :username, :password, :url

    def self.configure
      yield self
    end

    def initialize(username: nil, password: nil, url: nil)
      Fusion::Client.username ||= username
      Fusion::Client.password ||= password
      Fusion::Client.url ||= url
    end

    def add_job(template:, data:)
      logon

      path = "addjob?templatename=#{template}&sessionid=#{@session_id}"
      params = data
      request(:post, params, path)
    end

    def cancel_job(job_id:)
      logon

      path = 'canceljob'
      params = { JobID: job_id, SessionID: @session_id }
      request(:post, params, path)
    end

    def cancel_job(job_id:)
      logon

      path = 'bypasstimer'
      params = { JobID: job_id, SessionID: @session_id }
      request(:post, params, path)
    end


    def request(method, params, path)
      raise 'You need to configure Fusion::Client with your username and password.' unless Client.username && Client.password

      path ||= default_path
      url = Fusion::Client.url
      url += '/' unless url.last == '/'
      url += path

      case method
      when :post
        params = params.is_a?(Hash) ? params.to_json : params
        RestClient.post(url, params, :content_type => :json, :accept => :json, :timeout => nil) { |response, request, result, &block|
          handle_response(response, request, result)
        }
      else
        RestClient::Request.execute(:method => method, :url => url, :headers => {params: params, :accept => :json}, :timeout => nil) { |response, request, result, &block|
          handle_response(response, request, result)
        }
      end
    end

    def handle_response(response, request, result)
      case response.code
      when 200..299
        JSON.parse(response)
      when 400
        raise RestClient::BadRequest, response
      when 404
        raise RestClient::ResourceNotFound, response
      when 500
        raise RestClient::InternalServerError, response
      else
        Rails.logger.debug(response.inspect)
        Rails.logger.debug(request.inspect)
        raise result.to_s
      end
    end

    def logoff
      return unless @session_id.present?

      path = 'logoff'
      params = { SessionID: @session_id }

      begin
        request(:post, params, path)
      rescue => e
        # We don't really care if logoff failed. Log it and move on.
        Rails.logger.debug(e.message)
      end
    end

    private

    def logon
      return if @session_id.present?

      path = 'logon'
      params = { UserID: Client.username, Password: Client.password }
      response = request(:post, params, path)
      @session_id = response['SessionID']

      raise response['Message'].inspect unless @session_id.present?
    end

  end
end
