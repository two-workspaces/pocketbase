# Deploy and Host PocketBase on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/pocketbase-backend?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=pocketbase-backend)

[PocketBase](https://pocketbase.io/) is an open-source backend in a single Go binary: an embedded SQLite database with realtime subscriptions, a REST API, user authentication (password, one-time codes, OAuth2, MFA), file storage and an admin dashboard. Point your web or mobile app at it with the JavaScript or Dart SDK and skip writing a backend. This template runs PocketBase 0.40.6 with its data on a Railway volume and creates your superuser on first boot.

## About Hosting PocketBase

The stack is one service with one volume.

- **Built from the official release.** The image ([source](https://github.com/two-workspaces/pocketbase)) downloads the pinned PocketBase release from GitHub into a small Alpine image. No third-party build.
- **Superuser on first boot.** A one-time migration creates the superuser from `PB_ADMIN_EMAIL` and the generated `PB_ADMIN_PASSWORD`, so the dashboard is never left open for whoever finds the URL first.
- **Real client IPs.** PocketBase is set to read the client address from Railway's `X-Real-IP` header, so request logs and the built-in rate limiter see your users rather than Railway's proxy.
- **Encrypted settings.** Stored secrets (SMTP password, S3 keys, OAuth2 client secrets) are encrypted with the generated `PB_ENCRYPTION_KEY`.
- **Everything on the volume.** The database, uploaded files and backups live in `/pb_data`, so redeploys and upgrades keep your data.
- **Tiny footprint.** PocketBase idles at about 30 MB of RAM, so it fits the Free plan.

## Common Use Cases

- A backend for a web, mobile or desktop app: database, auth and file uploads behind one SDK
- Prototypes, hackathon projects and MVPs that need a real API in minutes
- Realtime features (live lists, chat, dashboards) through subscriptions
- Internal tools and admin panels on top of the built-in dashboard
- A self-hosted alternative to Firebase or Supabase for small and medium apps

## Dependencies for PocketBase Hosting

- A Railway volume at `/pb_data` (included)

### Deployment Dependencies

- [PocketBase documentation](https://pocketbase.io/docs/)
- [JavaScript SDK](https://github.com/pocketbase/js-sdk) and [Dart SDK](https://github.com/pocketbase/dart-sdk)
- [PocketBase on GitHub](https://github.com/pocketbase/pocketbase)
- [Template source on GitHub](https://github.com/two-workspaces/pocketbase)

### Implementation Details

**Sign in.** When the deploy is green, open `https://<your domain>/_/` and sign in with `PB_ADMIN_EMAIL` and the password in the PocketBase service's `PB_ADMIN_PASSWORD` variable. Both are only used on the first boot; change the password afterwards in the dashboard.

**Your app.** Create collections in the dashboard, set their API rules, then connect from your app:

```js
import PocketBase from 'pocketbase'
const pb = new PocketBase('https://<your domain>')
```

**Email.** Verification, password reset and one-time codes need SMTP, and Railway only allows outbound SMTP on the Pro plan. Set your provider in Settings, Mail settings.

**Hooks and migrations.** Fork the template repo and add JavaScript hooks to `pb_hooks/` and migrations to `pb_migrations/`. They are built into the image, so a push redeploys with your code.

**Custom domains.** Add the domain to the service in Railway, then update the Application URL in Settings, Application, so emails and OAuth2 redirects use it.

**Keep `PB_ENCRYPTION_KEY`.** Changing it after the first boot makes the stored settings unreadable.

**Back up.** Use Settings, Backups in the dashboard (to the volume or to S3-compatible storage), or Railway's volume backups.

**Upgrading.** Bump `PB_VERSION` in the Dockerfile of your fork and redeploy. Read the [release notes](https://github.com/pocketbase/pocketbase/releases) first; PocketBase is pre-1.0 and some releases change the API.

## Why Deploy PocketBase on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying PocketBase on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
