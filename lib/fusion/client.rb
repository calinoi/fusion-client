require 'fusion/client/version'
require 'json'
require 'active_support/all'
require 'rest-client'

module Fusion
  class Client
    URL = 'https://fusionpro1450.cloudapp.net/FusionProRestService/'

    class << self
      attr_accessor :username, :password

      def configure
        yield self
      end
    end

    def initialize(username: nil, password: nil)
      Fusion::Client.username ||= username
      Fusion::Client.password ||= password
    end

    def add_job(template:, data:, proof:)
      logon

      path = "addjob?templatename=#{template}&sessionid=#{@session_id}&bReturnSingleProof=#{proof}"
      params = data
      request(:post, params, path)
    end

    def cancel_job(job_id:)
      logon

      path = 'canceljob'
      params = { JobID: job_id, SessionID: @session_id }
      request(:post, params, path)
    end

    def bypass_timer(job_id:)
      logon

      path = 'bypasstimer'
      params = { JobID: job_id, SessionID: @session_id }
      request(:post, params, path)
    end


    def request(method, params, path)
      raise 'You need to configure Fusion::Client with your username and password.' unless Client.username && Client.password

      path ||= default_path
      url = URL
      url += path

      if params.is_a?(Hash)
        params = params.to_json
        content_type = 'application/json'
      else
        content_type = 'application/octet-stream'
      end
      RestClient::Request.execute(:method => method, :url => url, payload: params, :headers => {:accept => :json, content_type: content_type}, :timeout => nil, :verify_ssl => false) { |response, request, result, &block|
        handle_response(response, request, result)
      }
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
        puts response.inspect
        puts request.inspect
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

    #private

    def logon
      return if @session_id.present?

      path = 'logon'
      params = { UserID: Client.username, Password: Client.password }
      response = request(:post, params, path)
      @session_id = response['SessionID']

      raise response['Message'].inspect unless @session_id.present?

      response
    end

  end
end
