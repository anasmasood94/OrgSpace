# OrgSpace

A comprehensive Rails application for organization-based access control with age-based participation rules and parental consent workflows.

## Features

### 🔐 Authentication & User Management
- **Devise Integration**: Full-featured authentication system
- **Age Verification**: Date of birth validation during registration
- **Age-based Rules**: Different participation levels based on user age
- **Parental Consent**: Workflow for minors requiring parental approval

### 🏢 Organization Management
- **Multi-tenant Organizations**: Users can belong to multiple organizations
- **Role-based Access Control**: Different permission levels within organizations
- **Member Management**: Invite, assign roles, and manage member status
- **Organization Analytics**: Detailed reporting and member statistics

### 📊 Analytics & Reporting
- **Member Analytics**: Age distribution, role distribution, recent joiners
- **Organization Insights**: Member count, participation trends
- **Age-based Reporting**: Separate analytics for different age groups

### 🛡️ Security & Authorization
- **Pundit Integration**: Policy-based authorization
- **Age-appropriate Content**: Content filtering based on user age
- **Parental Consent Tracking**: Approval workflow for minors

## Installation & Setup

### Prerequisites
- Ruby 3.1.2 or higher
- Rails 7.2.2
- SQLite3 (or PostgreSQL for production)

### Installation Steps

1. **Clone the repository**
```bash
git clone <repository-url>
cd access_control_app
```

2. **Install dependencies**
```bash
bundle install
```

3. **Setup database**
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. **Start the server**
```bash
rails server
```

5. **Visit the application**



## User Registration with Age Verification

### Registration Process
1. Navigate to `/users/sign_up`
2. Fill in email and password
3. **Required**: Enter date of birth
4. System validates minimum age (13 years)
5. Account creation with age verification

### Age-based Restrictions
- **Under 13**: Cannot register (minimum age requirement)
- **13-17**: Can register but require parental consent
- **18+**: Full access without restrictions

### Example Registration Flow
```ruby
# User registration with age validation
user = User.new(
  email: "user@example.com",
  password: "password123",
  date_of_birth: Date.new(2005, 6, 15)  # 18 years old
)

if user.save
  # Registration successful
else
  # Age validation failed
end
```

## Organization Creation and Management

### Creating Organizations
1. **Access**: Navigate to `/organizations`
2. **Create**: Click "New Organization"
3. **Required Fields**:
   - Name (unique)
   - Description
   - Domain (unique)
   - Status (active/inactive/suspended)

### Organization Structure
```ruby
# Organization model
Organization.create!(
  name: "Tech Innovators",
  description: "Technology community",
  domain: "techinnovators.com",
  status: :active
)
```

### Default Roles Created
- **Admin Role**: Full permissions (manage organization, members, analytics)
- **Member Role**: Basic permissions (view analytics)

## Member Invitation and Role Assignment

### Adding Members
1. **Navigate**: Go to organization show page
2. **Add Member**: Click "Add Member" button
3. **Select**: Choose user and role
4. **Status**: Set membership status (active/pending/inactive)

### Role Assignment Process
```ruby
# Adding a member to an organization
membership = organization.memberships.create!(
  user: user,
  role: admin_role,
  status: :active
)
```

### Available Roles
- **Admin**: Full organization management
- **Member**: Basic participation
- **Custom Roles**: Organization-specific roles

### Permission System
```ruby
# Check user permissions
if user.role_in(organization).can_manage_members?
  # User can manage members
end

if user.role_in(organization).can_view_analytics?
  # User can view analytics
end
```

## Age-based Content Filtering

### Content Categories
- **Children (0-12)**: Restricted content
- **Teens (13-17)**: Age-appropriate content
- **Adults (18+)**: Full content access

### Implementation
```ruby
# Content filtering based on age
def age_appropriate_content_for(user)
  case user.age
  when 0..12
    content_for_children
  when 13..17
    content_for_teens
  else
    content_for_adults
  end
end
```

### Age Group Access
- **Minors**: Access to `/age_groups/minors`
- **Adults**: Access to `/age_groups/adults`
- **Content Filtering**: Automatic based on user age

## Parental Consent Workflow for Minors

### Consent Process
1. **Minor Registration**: User under 18 registers
2. **Consent Required**: System detects minor status
3. **Parent Email**: Minor provides parent's email
4. **Email Sent**: System sends consent request
5. **Parent Approval**: Parent approves/denies via email
6. **Access Granted**: Minor gains participation access

### Consent Tracking
```ruby
# Check if user needs parental consent
if user.requires_parental_consent?
  redirect_to new_parental_consent_path
end

# Check if consent is approved
if user.parental_consent_approved?
  # Allow participation
else
  # Restrict access
end
```

### Consent States
- **Pending**: Consent request sent, awaiting response
- **Approved**: Parent approved participation
- **Denied**: Parent denied participation

## Analytics and Reporting

### General Analytics (`/analytics`)
- **Total Organizations**: Count of all organizations
- **Total Members**: Count of all active members
- **Age Distribution**: Breakdown by age groups
- **Organization List**: Quick access to all organizations

### Organization Analytics (`/organizations/:id/analytics`)
- **Member Count**: Total active members
- **Role Distribution**: Members by role
- **Age Distribution**: Members by age group
- **Recent Joiners**: Latest member additions

### Analytics Implementation
```ruby
# Organization analytics service
analytics = OrganizationAnalytics.new(organization)

# Get member count
member_count = analytics.member_count

# Get age distribution
age_distribution = analytics.age_distribution

# Get role distribution
role_distribution = analytics.role_distribution
```

### Sample Analytics Data
```ruby
# Age distribution example
{
  "minors" => 15,
  "young_adults" => 25,
  "adults" => 45,
  "seniors" => 10
}

# Role distribution example
{
  "admin" => 5,
  "member" => 90
}
```

## API Endpoints

### Organizations




## Security Features

### Authorization (Pundit)
- **Policy-based**: Each model has corresponding policies
- **Role-based**: Permissions based on user roles
- **Organization-scoped**: Access limited to user's organizations

### Age Verification
- **Registration**: Date of birth required
- **Validation**: Minimum age enforcement
- **Content Filtering**: Age-appropriate content

### Parental Consent
- **Email Verification**: Parent email validation
- **Consent Tracking**: Approval status monitoring
- **Access Control**: Participation based on consent

## Testing

### Run Tests
```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/user_test.rb

# Run with coverage
COVERAGE=true rails test
```

### Test Coverage
- **Model Tests**: User, Organization, Membership, Role
- **Controller Tests**: CRUD operations, authorization
- **Integration Tests**: Complete user workflows
- **Policy Tests**: Authorization policies

## Deployment

### Production Setup
1. **Database**: Use PostgreSQL for production
2. **Environment**: Set production environment variables
3. **Assets**: Precompile assets
4. **Security**: Configure SSL and security headers

### Environment Variables
```bash
# Required for production
DATABASE_URL=postgresql://...
SECRET_KEY_BASE=your_secret_key
RAILS_ENV=production
```

## Contributing

### Development Setup
1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Submit pull request

### Code Standards
- **Ruby Style**: Follow RuboCop guidelines
- **Rails Conventions**: Follow Rails best practices
- **Testing**: Maintain good test coverage
- **Documentation**: Update README for new features

## Troubleshooting

### Common Issues

**Database Errors**
```bash
# Reset database
rails db:drop db:create db:migrate db:seed
```

**Permission Errors**
- Check user roles and permissions
- Verify organization membership
- Review Pundit policies

**Age Verification Issues**
- Ensure date_of_birth is set
- Check age calculation logic
- Verify parental consent status

### Debug Mode
```bash
# Start in debug mode
rails server -d

# Check logs
tail -f log/development.log
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the test files for examples

---
