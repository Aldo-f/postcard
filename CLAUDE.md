# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Postcard is a Rails 7 application that functions as a personal website builder with integrated newsletter and blogging functionality. It can run in two modes:
- **Solo mode** (default): Single-user self-hosted personal website
- **Multi-user mode**: SaaS platform supporting multiple users with custom domains

## Key Commands

### Development
```bash
# Start development server in solo mode (recommended)
./bin/dev-solo

# Start in multi-user mode
./bin/dev-multiuser

# Access the application at http://localtest.me:3000
# (localtest.me required due to hCaptcha constraints)

# Install dependencies
bundle install
npm install puppeteer

# Database setup
rails db:setup
rails db:migrate

# Run Rails console
rails console

# Run background jobs manually
bundle exec rake solid_queue:start
```

### Testing
```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/account_test.rb

# Run specific test
rails test test/models/account_test.rb:42
```

## Architecture & Key Concepts

### Application Modes
The application behavior significantly changes based on `APP_MODE` environment variable:
- **Solo mode** (`APP_MODE=SOLO`): Simplified single-user experience
  - No billing/payments
  - No subdomain routing
  - Auto-approves imports
  - GitHub issues for support instead of email
  - No feedback widget
- **Multi-user mode** (`APP_MODE=MULTIUSER`): Full SaaS features
  - Stripe integration for payments
  - Subdomain-based routing (username.postcard.page)
  - Domain verification system
  - Admin approval for imports
  - Email-based support

Configuration is centralized in `config/initializers/app_config.rb` with checks throughout using `Rails.configuration.solo_mode` or `Rails.configuration.multiuser_mode`.

### Core Models & Relationships
- **Account**: Main user model (via Devise). In solo mode, only one account can exist.
- **Post**: Blog posts with draft/published states, email newsletter integration
- **Subscription**: Newsletter subscribers linked to EmailAddress
- **Domain**: Custom domain management (multi-user mode only)
- **EmailAddress**: Normalized email storage to prevent duplicates

### Background Jobs (Solid Queue)
Configured in `config/solid_queue.yml`:
- `VerifyDomainsJob`: Checks custom domain DNS (multi-user only)
- `TelemetryJob`: Anonymous usage statistics (hourly)
- `EnqueueAnalyticsSummaryEmailsJob`: Weekly analytics emails
- `VisitsInLastDayJob`: Daily visitor tracking

### Key Features by Mode

**Solo Mode Specific**:
- First user automatically becomes admin
- No gallery feature
- Immediate CSV import processing
- Simplified onboarding flow

**Multi-user Mode Specific**:
- Stripe payment processing via Pay gem
- Custom domain routing through render-proxy
- Gallery showcase feature
- Manual CSV import approval by admin

### File Storage & Email
- **Production**: AWS S3 for file storage, AWS SES for email delivery
- **Development**: Local Active Storage, Letter Opener for emails

### Anonymous Telemetry
The app collects anonymous usage statistics (can be disabled with `DISABLE_ANONYMOUS_TELEMETRY=true`):
- Sends to self-hosted Plausible Analytics
- Only aggregate data: mode, versions, counts
- Implementation in `app/jobs/telemetry_job.rb`

### Frontend Stack
- Tailwind CSS with custom configuration
- Stimulus.js for JavaScript interactions
- Turbo for SPA-like navigation
- ViewComponent pattern in some areas

## Important Patterns

### Mode-Specific Behavior
Always check the application mode when implementing features:
```ruby
if Rails.configuration.solo_mode
  # Solo-specific logic
elsif Rails.configuration.multiuser_mode
  # Multi-user specific logic
end
```

### Account Resolution
- Solo mode: Always uses `Account.first`
- Multi-user mode: Resolves by subdomain or custom domain

### Email Sending
- Use `ApplicationMailer` base class
- Emails automatically include tracking via Ahoy
- In development, emails open in browser via Letter Opener

### Background Processing
- Use Rails' built-in Active Job framework
- Jobs are processed by Solid Queue
- Add recurring jobs to `config/solid_queue.yml`

## Environment Variables

Critical variables for production:
- `APP_MODE`: SOLO or MULTIUSER
- `BASE_HOST`: Your domain (e.g., example.com)
- `SECRET_KEY_BASE`: Rails secret (generate with `rails secret`)
- `DATABASE_URL`: PostgreSQL connection
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_STORAGE_BUCKET`: Required for S3
- `HCAPTCHA_SITE_KEY`, `HCAPTCHA_SECRET_KEY`: Required for spam protection

See `README.md` for complete list and `config/initializers/app_config.rb` for all available options.