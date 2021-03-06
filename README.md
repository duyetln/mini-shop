# Mini shop

## Overview

Mini shop is a simple online shopping store built for my personal learning and coding pleasure. I work on the shop for a few hours after work everyday and build it with a heavy focus on code cleaness, good practice/design patterns, and quality over speed. I strive to make it as (reasonably) complex as possible to expose myself to a wide range of problems (such as testing, integration, service implementation...) and force myself to learn and improve. The shop is still work in progress and only contains a backend system now. In the future, new features, a frontend, and an admin component will be added.

## Goals

Here are the goals set for this project:

  * Solid test suite: unit tests, integration tests, and good test coverage.
  * DRY and clean code.
  * Good separation of concerns and code reuse (mostly achieved via polymorphism and composition).
  * Good design patterns.
  * Mastery of the Ruby language.

## Screenshots

### Admin
![](images/admin_index.png)
![](images/admin_create_bundle.png)

### Frontend
![](images/frontend_index.png)
![](images/frontend_purchases.png)

See more [here](./images).

## Releases

  * 0.1.0:
    - Add service endpoints for creating and authenticating user accounts.
    - Add service endpoints for creating and managing inventory items.
    - Add service endpoints for creating, fulfilling, and reversing purchases.
  * 0.1.1:
    - Add missing endpoints for a few inventory service endpoints.
  * 0.2.0:
    - Add service endpoints for creating and managing promotions and coupons.
    - Allow purchase to fulfill even when total amount is zero.
    - Store items are no longer activable.
    - Remove nested service path in favor of leaner api.
    - Inventory items now cannot be deleted when active.
  * 0.3.0
    - Add service endpoints for sending account activation, purchase receipt, and purchase status emails.
  * 0.3.1
    - Use routing table in favor of stacking service endpoints as middlewares.
  * 0.3.2
    - Include item quantity in bundle response payload.
  * 0.4.0
    - Update response payloads of a few endpoints.
    - Remove endpoints to retrieve a user's addresses or payment methods.
    - Add endpoints to retrieve a user's transactions and redeemed coupons, to update a batch, to generate coupons for a batch, to return all users, and to retrieve a specific inventory item.
    - Add client for backend service endpoints.
  * 0.5.0
    - Add pagination support for a few endpoints.
  * 0.5.1
    - Require explicit update parameter whitelisting for backend client.
  * 0.6.0
    - Rework and drastically improve backend client.
    - Add endpoints to retreive specific batch, pricepoint, and discount by id.
    - Remove endpoint to retreive user's addresses.
    - Add nicer error messages to both backend and client.
    - Add additional attributes to response payloads of a few resources.
  * 0.7.0
    - Paginate endpoints that return user's transactions, shipments, ownerships, coupons, and purchases.
    - Sort paginated result by id in descending order.
    - Improve backend client.
    - Add admin interface to manage the system.
  * 0.8.0
    - Separate transaction models into two types.
    - Add timestamps to all resource payloads.
    - Associate billing address with payment method instead transaction.
    - Add additional fields to purchase, order, payment method, and transaction payloads.
    - Update and add in-memory caching to backend client.
  * 0.9.0
    - Add frontend component to display and purchase products.

