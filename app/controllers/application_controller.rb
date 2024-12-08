class ApplicationController < ActionController::API
  def pong
    render json: { message: "pong" }, status: :ok
  end
end
