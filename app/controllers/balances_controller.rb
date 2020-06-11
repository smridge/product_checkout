# frozen_string_literal: true

class BalancesController < ApplicationController
  before_action :set_organization

  def show
    return head :bad_request if @organization.blank?

    render json: CreditBalanceResult.new(organization: @organization).perform
  rescue NoMethodError => _e
    render json: { error: "Could not retrieve balance" }, status: :unprocessable_entity
  end

  private

  def set_organization
    @organization = Organization.find_by(slug: params[:org_slug])
  end
end
