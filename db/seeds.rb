# Clear existing data (optional - uncomment if you want to reset)
# Organization.destroy_all
# Role.destroy_all
# User.destroy_all

# Create age groups
minors_group = AgeGroup.find_or_create_by(name: "Minors") do |ag|
  ag.description = "Users aged 13-17"
  ag.min_age = 13
  ag.max_age = 17
end

adults_group = AgeGroup.find_or_create_by(name: "Adults") do |ag|
  ag.description = "Users aged 18 and above"
  ag.min_age = 18
  ag.max_age = nil
end

# Create test organizations (only if they don't exist)
org1 = Organization.find_or_create_by(name: "Tech Innovators") do |org|
  org.description = "A community for technology enthusiasts"
  org.domain = "techinnovators.com"
  org.status = :active
end

org2 = Organization.find_or_create_by(name: "Youth Leadership") do |org|
  org.description = "Leadership development for young people"
  org.domain = "youthleadership.org"
  org.status = :active
end

# Create roles (now independent of organizations)
admin_role = Role.find_or_create_by(name: 'admin') do |role|
  role.permissions = [
    'manage_organization', 'manage_members', 'view_analytics',
    'create_post', 'edit_post', 'delete_post',
    'create_organization', 'edit_organization', 'delete_organization'
  ]
end

member_role = Role.find_or_create_by(name: 'member') do |role|
  role.permissions = ['view_analytics']
end

# Create organization roles
[org1, org2].each do |org|
  org.organization_roles.find_or_create_by(role: admin_role)
  org.organization_roles.find_or_create_by(role: member_role)
end

# Create participation rules
[org1, org2].each do |org|
  # Rules for minors
  org.participation_rules.find_or_create_by(age_group: minors_group) do |rule|
    rule.can_join = true
    rule.can_view_content = true
    rule.can_participate_in_activities = true
    rule.requires_parental_consent = true
    rule.content_restrictions = "Age-appropriate content only"
    rule.activity_restrictions = "Supervised activities only"
  end

  # Rules for adults
  org.participation_rules.find_or_create_by(age_group: adults_group) do |rule|
    rule.can_join = true
    rule.can_view_content = true
    rule.can_participate_in_activities = true
    rule.requires_parental_consent = false
    rule.content_restrictions = "Full content access"
    rule.activity_restrictions = "All activities available"
  end
end

puts "Seeds completed successfully!"
puts "Created #{AgeGroup.count} age groups"
puts "Created #{Organization.count} organizations"
puts "Created #{Role.count} roles"
puts "Created #{OrganizationRole.count} organization roles"
puts "Created #{ParticipationRule.count} participation rules"
puts ""
puts "Next steps:"
puts "1. Create admin users for each organization"
puts "2. Run: rails db:migrate"
puts "3. Run: rails db:seed"