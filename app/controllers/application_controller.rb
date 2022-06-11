class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    def not_found(e)
        render json: {error: e}, status: :unprocessable_entity
    end
end
