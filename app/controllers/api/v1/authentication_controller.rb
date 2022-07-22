class Api::V1::AuthenticationController < ApplicationController
    class AuthenticationError < StandardError; end

    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from AuthenticationError, with: :handle_unauthenticated
    def create
        raise AuthenticationError unless user.authenticate(params.require(:password))

        token = AuthenticationTokenService.encode(user.id)
        render json: { token: token }, status: :created
    end

    private
    
    def user
        @user ||= User.find_by(username: params.require(:username))
    end

    # Parameter e is passed by rescue_from. You can move it if you want to.
    def parameter_missing(e)
        render json: { error: e.message }, status: :unprocessable_entity
    end
    
    def handle_unauthenticated
        head :unauthorized
    end
end