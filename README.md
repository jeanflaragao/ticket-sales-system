# Ticket Sales System 🎫

A robust and scalable ticket sales API built with Ruby on Rails, designed for managing show inventory and processing ticket orders with real-time inventory tracking.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [API Documentation](#api-documentation)
- [Database Schema](#database-schema)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)

## ✨ Features

### Core Functionality

- **Show Management**: Create, read, and manage show inventory
- **Order Processing**: Complete order lifecycle with inventory validation
- **Inventory Tracking**: Real-time available, reserved, and sold inventory tracking
- **Order Status Management**: Pending, confirmed, cancelled, and failed order states
- **Email Validation**: RFC-compliant customer email validation
- **Concurrent Safety**: Built-in inventory protection against overselling

### Technical Features

- **RESTful API**: Clean, intuitive API endpoints
- **Real-time Inventory**: Automatic inventory updates on order completion
- **Background Jobs**: Sidekiq integration for async processing
- **Health Monitoring**: Built-in health check endpoints
- **Comprehensive Testing**: Full RSpec test suite with 33+ test cases
- **Docker Ready**: Complete containerization with Docker Compose
- **Database Optimization**: Indexed queries for performance

## 🛠 Tech Stack

- **Framework**: Ruby on Rails 7.1.6
- **Language**: Ruby 3.2.2
- **Database**: PostgreSQL 15
- **Cache/Jobs**: Redis 7 + Sidekiq
- **Testing**: RSpec, FactoryBot
- **Containerization**: Docker & Docker Compose
- **Development**: Solargraph (LSP), Bullet (N+1 detection)

## 📋 Prerequisites

- Docker and Docker Compose
- Git

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/jeanflaragao/ticket-sales-system.git
cd ticket-sales-system
```

### 2. Start Services with Docker

```bash
# Start all services (database, redis, web application)
docker compose up -d

# Setup the database
docker compose exec web rails db:setup

# Verify installation
docker compose exec web rails db:seed
```

### 3. Verify Installation

```bash
# Check health endpoint
curl http://localhost:3000/health

# View seeded shows
curl http://localhost:3000/shows
```

The application will be available at `http://localhost:3000`

## 📚 API Documentation

### Base URL

```
http://localhost:3000
```

### Headers

All requests should include:

```
Content-Type: application/json
Accept: application/json
```

### Endpoints

#### Shows

**Get All Shows**

```http
GET /shows
```

Returns all available shows with inventory information.

**Get Show Details**

```http
GET /shows/:id
```

**Create Show**

```http
POST /shows
Content-Type: application/json

{
  "show": {
    "name": "Hamilton",
    "total_inventory": 100,
    "price": 150.00
  }
}
```

**Check Show Availability**

```http
GET /shows/:id/availability
```

#### Orders

**Get All Orders**

```http
GET /orders
```

Returns orders with associated items and shows.

**Get Order Details**

```http
GET /orders/:id
```

**Create Order**

```http
POST /orders
Content-Type: application/json

{
  "customer_email": "customer@example.com",
  "items": [
    {
      "show_id": 1,
      "quantity": 2
    }
  ]
}
```

**Cancel Order**

```http
POST /orders/:id/cancel
```

#### System

**Health Check**

```http
GET /health
```

Returns system status and basic metrics.

### Response Format

**Success Response (200/201)**

```json
{
  "id": 1,
  "name": "Hamilton",
  "total_inventory": 100,
  "available_inventory": 95,
  "price": "150.0"
}
```

**Error Response (422)**

```json
{
  "errors": ["Name can't be blank", "Insufficient inventory for Hamilton"]
}
```

## 🗄 Database Schema

### Shows

- `id`: Primary key
- `name`: Show name (unique, required)
- `total_inventory`: Total available tickets
- `reserved_inventory`: Currently reserved tickets
- `sold_inventory`: Sold tickets
- `price`: Ticket price (decimal)
- `created_at`, `updated_at`: Timestamps

### Orders

- `id`: Primary key
- `customer_email`: Customer email (validated)
- `status`: Order status (pending/confirmed/cancelled/failed)
- `total`: Order total amount
- `created_at`, `updated_at`: Timestamps

### Order Items

- `id`: Primary key
- `order_id`: Foreign key to orders
- `show_id`: Foreign key to shows
- `quantity`: Number of tickets
- `price`: Price per ticket at time of purchase
- Unique constraint on `[order_id, show_id]`

## 💻 Development

### Local Development Setup

**Start development environment:**

```bash
docker compose up -d db redis
bundle install
rails server
```

**Run console:**

```bash
# In Docker
docker compose exec web rails console

# Local
rails console
```

**Database operations:**

```bash
# Migrations
docker compose exec web rails db:migrate

# Rollback
docker compose exec web rails db:rollback

# Reset database
docker compose exec web rails db:reset
```

### Code Quality

**Run linter:**

```bash
bundle exec rubocop
```

**Performance monitoring:**

```bash
# Bullet gem will detect N+1 queries in development
```

### Background Jobs

**Monitor Sidekiq:**

```bash
# Access Sidekiq Web UI (if configured)
open http://localhost:4567

# Check job status
docker compose exec web sidekiq
```

## 🧪 Testing

The project includes a comprehensive test suite with 33+ test cases covering:

- Model validations and associations
- Controller actions and responses
- Service object functionality
- Edge cases and error handling

**Run all tests:**

```bash
# In Docker (recommended)
docker compose exec -e RAILS_ENV=test web bundle exec rspec

# Local
RAILS_ENV=test bundle exec rspec
```

**Run specific tests:**

```bash
# Shows API tests
docker compose exec -e RAILS_ENV=test web bundle exec rspec spec/requests/shows_spec.rb

# Orders API tests
docker compose exec -e RAILS_ENV=test web bundle exec rspec spec/requests/orders_spec.rb

# Service tests
docker compose exec -e RAILS_ENV=test web bundle exec rspec spec/services/
```

**Test with coverage:**

```bash
docker compose exec -e RAILS_ENV=test web bundle exec rspec --format documentation
```

### Test Data

The system includes factories for generating test data:

- `create(:show)` - Creates a show with default inventory
- `create(:order)` - Creates an order with items
- `create(:order_item)` - Creates individual order items

## 🚀 Deployment

### Docker Deployment

**Production build:**

```bash
docker compose -f docker-compose.prod.yml up -d
```

**Environment variables:**

```bash
# Required for production
DATABASE_URL=postgresql://user:pass@host:5432/db_name
REDIS_URL=redis://host:6379/0
RAILS_MASTER_KEY=your_master_key
```

### Health Monitoring

The application provides health check endpoints for monitoring:

- `GET /health` - Application health status
- Database connectivity check
- Redis connectivity check

### Scaling Considerations

- **Database**: PostgreSQL with proper indexing for high read loads
- **Background Jobs**: Sidekiq can be scaled horizontally
- **Web Servers**: Rails app is stateless and can be horizontally scaled
- **Caching**: Redis can be used for caching frequently accessed data

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Run the test suite (`docker compose exec -e RAILS_ENV=test web bundle exec rspec`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Development Guidelines

- Follow Ruby/Rails best practices
- Write tests for all new features
- Use meaningful commit messages
- Update documentation for API changes
- Ensure all tests pass before submitting PRs

### Code Style

This project follows standard Ruby/Rails conventions:

- Use 2 spaces for indentation
- Follow Rails naming conventions
- Write descriptive method and variable names
- Add comments for complex business logic

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:

- Create an issue in the GitHub repository
- Check the API documentation above
- Review the test suite for usage examples

---

Built with ❤️ using Ruby on Rails
