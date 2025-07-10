class OrganizationAnalytics
  attr_reader :organization

  def initialize(organization)
    @organization = organization
  end

  def member_count
    @member_count ||= organization.organization_memberships.active.count
  end

  def age_distribution
    @age_distribution ||= organization.users.joins(:organization_memberships)
      .where(organization_memberships: { status: :active })
      .group("CASE 
        WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) < 18 THEN 'minors'
        WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) BETWEEN 18 AND 25 THEN 'young_adults'
        WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) BETWEEN 26 AND 50 THEN 'adults'
        ELSE 'seniors'
      END")
      .count
  end

  def role_distribution
    organization.organization_memberships.active
      .group(:member_type)
      .count
  end

  def recent_joiners
    @recent_joiners ||= organization.organization_memberships.active
      .includes(:user)
      .order(joined_at: :desc)
      .limit(5)
  end

  # Returns the top 5 most viewed posts in the organization
  def most_viewed_posts(limit = 5)
    organization.posts.order(views_count: :desc).limit(limit)
  end

  # Returns the number of posts created in the last week
  def posts_count_last_week
    organization.posts.where('created_at >= ?', 1.week.ago).count
  end

  # Returns the number of minors in the organization
  def minors_count
    organization.users.joins(:organization_memberships)
      .where(organization_memberships: { status: :active })
      .where(minor: true).distinct.count
  end

  # Returns the admin users of the organization
  def admin_users
    organization.admin_users
  end

  # Returns the top 3 users who created the most posts in the organization
  def top_post_creators(limit = 3)
    organization.posts.group(:user_id)
      .order('COUNT(id) DESC')
      .limit(limit)
      .count
      .map { |user_id, count| [User.find_by(id: user_id), count] }
  end

  # Returns a hash with post counts by age group category (All, Minors, Adults)
  def posts_count_by_category
    {
      'All' => organization.posts.where(age_group_id: nil).count,
      'Minors' => organization.posts.joins(:age_group).where(age_groups: { name: 'Minors' }).count,
      'Adults' => organization.posts.joins(:age_group).where(age_groups: { name: 'Adults' }).count
    }
  end
end