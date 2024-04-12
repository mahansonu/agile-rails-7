class SupportRequestsController < ApplicationController
  def index
    @supports = SupportRequest.all
  end

  def update
    support = SupportRequest.find(params[:id])
    support.update(response: params.require(:support_request)[:response])
    SupportRequestMailer.respond(support).deliver_now
    redirect_to support_requests_path
  end
end
