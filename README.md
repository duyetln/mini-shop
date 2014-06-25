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
    - Include item quantity in the response of Bundle endpoints.
