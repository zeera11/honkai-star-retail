# Honkai Star Retail

Honkai Star Retail is a Flutter-based mobile commerce application inspired by the Honkai universe. The platform allows users to browse, search, and purchase various galactic resources and light cones while providing administrators with a complete inventory management system.

The application demonstrates the implementation of a full-stack mobile application using Flutter, Node.js, Express, MySQL, JWT Authentication, and Google OAuth.

## Key Features

### Customer Features

* Browse available resources and light cones
* View detailed product information
* Search and filter products by category
* Add products to cart
* Purchase products with custom quantities
* View transaction history
* Secure authentication and authorization

### Administrator Features

* Create new products
* Update product information
* Delete products
* Manage stock availability
* Monitor inventory records

### Authentication Features

* Email and password authentication
* Google OAuth login
* JWT-based authorization
* Protected API endpoints

## Tech Stack

### Frontend

* Flutter
* Dart
* Material Design

### Backend

* Node.js
* Express.js

### Database

* MySQL

### Authentication

* JWT (JSON Web Token)
* Google OAuth

### API

* RESTful API

## Application Architecture

```text
Flutter Mobile App
          │
          ▼
REST API (Express.js)
          │
          ▼
MySQL Database
```

## Technical Highlights

### Role-Based Access Control (RBAC)

The system implements two user roles:

* Admin
* Customer

Each role has different permissions and access levels throughout the application.

### Product Management System

Administrators can perform complete CRUD operations on resources:

* Create products
* Read products
* Update products
* Delete products

### Authentication & Security

Authentication is implemented using JWT tokens and Google OAuth integration. Protected routes require token verification before allowing access to secured resources.

### Data Validation

The application validates user input before submission, including:

* Required fields
* Email format validation
* Password requirements
* Numeric validation for stock and price
* Purchase quantity validation

## Database Entities

### Users

* id
* name
* email
* password
* role

### Resources

* id
* name
* type
* description
* stock
* image
* price

### Transactions

* id
* userId
* resourceId
* quantity
* totalPrice
* createdAt

## API Endpoints

### Authentication

```http
POST /auth/register
POST /auth/login
POST /auth/google
GET  /auth/profile
```

### Resources

```http
GET    /resources
GET    /resources/:id
POST   /resources
PUT    /resources/:id
DELETE /resources/:id
```

### Transactions

```http
POST /transactions
GET  /transactions/history
```

## Screenshots

*Add application screenshots here.*

## Future Improvements

* Wishlist functionality
* Product review system
* Payment gateway integration
* Push notifications
* Product recommendation system
* Order tracking
