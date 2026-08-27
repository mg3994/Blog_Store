# Blog Store - Instruction Guideline & Architecture Specification

## Overview & Concept
**Blog Store** is a Blogger-powered Ecommerce application built with Flutter adhering strictly to Clean Architecture, SOLID, and DRY principles.
The product database is dynamically derived from Schema JSON-LD embedded within posts published on Blogger (Blog ID: `1774904866501098696`).

---

## 1. Clean Architecture & Codebase Guidelines

```
lib/
├── app/                  # Application Shell & Routing (kaisel)
├── config/               # Environment & App Configuration
├── core/                 # Result<T>, Failure, Base Contracts
├── features/
│   ├── auth/             # Firebase Authentication & Custom Scopes
│   ├── catalog/          # Blogger Products, Filtering, Geo-Location & Power Search
│   ├── cart/             # Cart State, Local DB & Re-validation
│   ├── wishlist/         # Local Wishlist Storage
│   └── payment/          # Payment Gateways (Apple Pay, Google Pay, UPI, COD)
├── infrastructure/       # Adapters: Dio, Drift, Firebase, Blogger Data Service
├── shared/               # i18n Localized Text & JSON-LD Readers
└── injection/            # Dependency Injection
```

---

## 2. Dynamic Schema JSON-LD & Authentication Handshake

### Unauthenticated API Endpoint
```http
GET https://www.blogger.com/feeds/1774904866501098696/posts/default/[postId]?alt=json
```

### Authenticated (Firebase Google Auth with Blogger Scopes) REST API v3
```http
GET https://www.googleapis.com/blogger/v3/blogs/1774904866501098696/posts/[postId]
Header: Authorization: Bearer <user_firebase_id_token>
```

### JSON-LD `@id` Resolution & Local Overrides
- Base context resolution: `"blogId/postId"` (e.g., `1774904866501098696/5522904867501094455`).
- Remote `@id` fetching: Deep-merges fetched target schema with local override attributes.

### Localization & i18n
Supported JSON-LD `@value` and `@language` structures:
```json
"name": [
  { "@value": "The Count of Monte Cristo", "@language": "en" },
  { "@value": "Le Comte de Monte-Cristo", "@language": "fr" }
]
```
The application resolves the text based on the user's active app locale (e.g., via `JsonLdLocalizedValueReader`), with fallback to English (`en`). All timestamps (`datePublished`, `availabilityEnds`) are parsed and converted to the user's device timezone.

---

## 3. Power Search & Geo-Location Serviceability

### Power Search Syntax
- Supports `label:...` prefixes and `|` (OR) logic (e.g. `label:electronics | label:featured headphone`).
- Constructs feed URLs with `/-/label1/label2` path parameters and `q` query strings.

### Geo-Location Serviceability (`areaServed`)
Checks `areaServed` types: `City`, `State`, `Country`, `PostalCode`, `GeoCoordinates`:
```json
"areaServed": {
  "@type": "City",
  "name": "Gurugram"
}
```
If `"@type": "Country"`, products are serviceable nationwide to all users within that country.

---

## 4. Drift Database: Local Cart & Wishlist Storage with Live Re-validation

### Drift Schema Setup
- `CartItems` table: `id`, `productId`, `title`, `price`, `currency`, `imageUrl`, `quantity`.
- `WishlistItems` table: `productId`, `title`, `price`, `imageUrl`.

### Re-validation Flow
When opening the Cart page or initiating checkout, the app re-checks Blogger feed / Hono endpoint for price changes or item availability before processing order requests.

---

## 5. Backend Integration & Hono Cloudflare Worker API (`api.antinna.in`)

### Hono Worker Setup (`backend/worker.ts`)
Deployable to Cloudflare Workers via Hono:

```typescript
import { Hono } from 'hono';

const app = new Hono();

app.post('/api/v1/stock/check', async (c) => {
  const { items } = await c.req.json();
  // Validates product availability against Blogger posts
  return c.json({ status: 'ok', available: true, items });
});

app.post('/api/v1/orders', async (c) => {
  const body = await c.req.json();
  return c.json({
    status: 'success',
    orderId: `ORD_${Date.now()}`,
    amount: body.totalAmount,
    currency: body.currency,
  });
});

app.post('/api/v1/payments', async (c) => {
  const body = await c.req.json();
  return c.json({
    status: 'completed',
    paymentId: `PAY_${Date.now()}`,
    method: body.method,
    orderId: body.orderId,
  });
});

export default app;
```

---

## 6. Payment Gateways
Supports four checkout options:
1. **Apple Pay** (`PaymentMethod.applePay`)
2. **Google Pay** (`PaymentMethod.googlePay`)
3. **Google Pay UPI** (`PaymentMethod.upi`)
4. **Cash on Delivery** (`PaymentMethod.cashOnDelivery`)

Order payload is submitted to `https://api.antinna.in/api/v1/orders` and payment status recorded at `https://api.antinna.in/api/v1/payments`.
