# OrgSpace

A comprehensive Rails application for organization-based access control with age-based participation rules and parental consent workflows.

## Features

### Authentication & User Management
- **Devise Integration**: Full-featured authentication system
- **Age Verification**: Date of birth validation during registration
- **Age-based Rules**: Different participation levels based on user age
- **Parental Consent**: Workflow for minors requiring parental approval

### Organization Management
- **Role-based Access Control**: Different permission levels within organizations
- **Member Management**: Invite, assign roles, and manage member status
- **Organization Analytics**: Detailed reporting and member statistics

### Analytics & Reporting
- **Member Analytics**: Age distribution, role distribution, recent joiners
- **Organization Insights**: Member count, participation trends
- **Age-based Reporting**: Separate analytics for different age groups

### Security & Authorization
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
cd orgSpace
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
   - Navigate to `http://localhost:3000`
   - Sign up for a new account

## User Registration with Age Verification

### Registration Process
1. Navigate to `/users/sign_up`
2. Fill in email and password
3. **Required**: Enter date of birth
4. **Optional**: Create organization during registration
5. System validates minimum age (13 years)
6. Account creation with age verification

### Age-based Restrictions
- **Under 13**: Cannot register (minimum age requirement)
- **13-17**: Can register but require parental consent for participation
- **18+**: Full access without restrictions

### Organization Creation During Registration
Users can create an organization during registration by providing:
- Organization name
- Organization description

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

## Organization Management

### Creating Organizations
1. **During Registration**: Create organization during signup
2. **Required Fields**:
   - Name (unique)
   - Description

### Default Roles Created
- **Admin Role**: Full permissions (manage organization, members, analytics, create/edit posts)
- **Member Role**: Basic permissions (view analytics, Read Posts)

## Member Management

### Adding Members
1. **Navigate**: Go to organization show page
2. **Add Member**: Click "Add Member" button
3. **Provide**: Email, date of birth, password, member type, and status
4. **System**: Creates user account and membership in one step

### Member Types
- **Admin**: Full organization management
- **Member**: Basic participation

### Membership Status
- **Active**: Full participation
- **Pending**: Awaiting approval
- **Inactive**: Suspended access

### Permission System
```ruby
# Check user permissions
if user.has_permission?('edit_organization', organization)
  # User can edit organization
end

if user.has_permission?('create_post', organization)
  # User can create posts
end
```

## Posts and Content Management

### Creating Posts
1. **Navigate**: Go to organization show page
2. **Create Post**: Click "Create Post" button (admin only)
3. **Fill**: Title, content, and age group
4. **Publish**: Post is created and visible to appropriate users

### Content Access Rules
- **Adults**: Can view all posts
- **Minors**: Can only view posts for their age group or "All Ages" posts
- **Admins**: Can view and manage all posts

## Age-based Access Control

### Age Groups
- **Minors**: Users under 18 years old
- **Adults**: Users 18 years and older

### Content Categories
- **All Ages**: Content visible to everyone
- **Minors**: Content visible only to users under 18
- **Adults**: Content visible only to users 18+

## Parental Consent Workflow for Minors

### Consent Process
1. **Minor Registration**: User under 18 registers
2. **Consent Required**: System detects minor status
3. **Parent Email**: Minor provides parent's email
4. **Email Sent**: System sends consent request
5. **Parent Approval**: Parent approves/denies via email link
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

### Email Workflow
- **Request Email**: Sent to parent with approval/denial links
- **Approval Link**: Parent clicks to approve consent
- **Denial Link**: Parent clicks to deny consent
- **Notification**: User receives notification about consent status

## Analytics and Reporting

### General Analytics (`/analytics`)
- **Total Organizations**: Count of all organizations
- **Total Members**: Count of all active members
- **Age Distribution**: Breakdown by age groups
- **Organization List**: Quick access to all organizations

### Organization Analytics (`/organizations/:id/analytics`)
- **Member Count**: Total active members
- **Minors Count**: Number of users under 18
- **Role Distribution**: Members by role
- **Age Distribution**: Members by age group
- **Recent Joiners**: Latest member additions
- **Top Post Creators**: Users who create the most posts
- **Most Viewed Posts**: Popular posts in the organization

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
- `GET /organizations` - List all organizations
- `GET /organizations/:id` - Show organization details
- `POST /organizations` - Create new organization
- `PATCH /organizations/:id` - Update organization
- `DELETE /organizations/:id` - Delete organization
- `GET /organizations/:id/analytics` - Organization analytics

### Memberships
- `GET /organizations/:id/memberships` - List organization members
- `POST /organizations/:id/memberships` - Add new member
- `PATCH /organizations/:id/memberships/:id` - Update membership
- `DELETE /organizations/:id/memberships/:id` - Remove member

### Posts
- `GET /organizations/:id/posts` - List organization posts
- `POST /organizations/:id/posts` - Create new post
- `GET /organizations/:id/posts/:id` - Show post details
- `PATCH /organizations/:id/posts/:id` - Update post
- `DELETE /organizations/:id/posts/:id` - Delete post

### Parental Consent
- `GET /parental_consent/new` - New consent request
- `POST /parental_consent` - Create consent request
- `GET /consent/approve/:id` - Approve consent (email link)
- `GET /consent/deny/:id` - Deny consent (email link)

### Analytics
- `GET /analytics` - General analytics dashboard

## Security Features

### Authorization (Pundit)
- **Policy-based**: Each model has corresponding policies
- **Role-based**: Permissions based on user roles
- **Organization-scoped**: Access limited to user's organizations

### Age Verification
- **Registration**: Date of birth required
- **Validation**: Minimum age enforcement (13 years)
- **Content Filtering**: Age-appropriate content

### Parental Consent
- **Email Verification**: Parent email validation
- **Consent Tracking**: Approval status monitoring
- **Access Control**: Participation based on consent

### Helper Methods
- **View Helpers**: Organization-specific helper methods moved to helper files
- **Clean Architecture**: Separation of concerns between models, views, and helpers


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
