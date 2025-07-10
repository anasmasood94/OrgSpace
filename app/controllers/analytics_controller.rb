class AnalyticsController < ApplicationController
  def index
    @organizations = policy_scope(Organization)
    @total_members = User.joins(:organization_memberships).where(organization_memberships: { status: :active }).distinct.count
    @age_distribution = User.joins(:organization_memberships)
      .where(organization_memberships: { status: :active })
      .group("CASE 
        WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) < 18 THEN 'minors'
        WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) BETWEEN 18 AND 25 THEN 'young_adults'
        WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) BETWEEN 26 AND 50 THEN 'adults'
        ELSE 'seniors'
      END")
      .count
  end

  def organization
    @organization = Organization.find(params[:id])
    authorize @organization
    @analytics = OrganizationAnalytics.new(@organization)
  end
end