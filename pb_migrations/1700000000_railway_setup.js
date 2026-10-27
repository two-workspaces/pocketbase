/// <reference path="../pb_data/types.d.ts" />
// Runs once, on the first boot (PocketBase records it in _migrations):
// creates the superuser from PB_ADMIN_EMAIL / PB_ADMIN_PASSWORD so the public
// URL never shows the installer, and takes client IPs from Railway's proxy.
migrate((app) => {
  const email = $os.getenv("PB_ADMIN_EMAIL")
  const password = $os.getenv("PB_ADMIN_PASSWORD")
  if (email && password) {
    const su = new Record(app.findCollectionByNameOrId("_superusers"))
    su.set("email", email)
    su.set("password", password)
    app.save(su)
  }

  const settings = app.settings()
  settings.trustedProxy.headers = ["X-Real-IP"]
  const url = $os.getenv("PB_APP_URL")
  if (url) settings.meta.appURL = url
  app.save(settings)
})
