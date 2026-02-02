# Railway Email Fix - SMTP Blocked

## ⚠️ Problem

Railway blocks outbound SMTP connections (ports 25, 465, 587, 2525). Your test shows the connection hangs and times out.

## ✅ Solution: Use Resend API (Free & Works on Railway)

### Step 1: Create Resend Account

1. Go to https://resend.com
2. Sign up (Free: 3,000 emails/month, 100/day)
3. Verify your email
4. Go to **API Keys** section
5. Click **Create API Key**
6. Copy the key (starts with `re_`)

### Step 2: Update Railway Environment Variables

Go to Railway Dashboard → Your Project → **Variables**, then **ADD** or **UPDATE**:

```env
MAIL_MAILER=resend
RESEND_KEY=re_your_api_key_here
MAIL_FROM_ADDRESS=rthrcapistrano@gmail.com
MAIL_FROM_NAME="STII E-Vote System"
```

**REMOVE or COMMENT OUT** these (not needed with Resend):

- ~~MAIL_HOST~~
- ~~MAIL_PORT~~
- ~~MAIL_USERNAME~~
- ~~MAIL_PASSWORD~~
- ~~MAIL_ENCRYPTION~~

### Step 3: Verify Domain (Optional but Recommended)

For production use:

1. In Resend dashboard, go to **Domains**
2. Add your domain
3. Add the DNS records they provide
4. Wait for verification
5. Update `MAIL_FROM_ADDRESS` to use your domain

For testing, you can use:

```
MAIL_FROM_ADDRESS=onboarding@resend.dev
```

### Step 4: Deploy

Railway will auto-deploy. Then test with:

```
https://stii-evote-production.up.railway.app/test-email.php
```

---

## 📧 Alternative: Try Password Without Spaces

If you prefer to keep using Gmail SMTP (though Railway blocks it), try:

**On Railway, set:**

```
MAIL_PASSWORD=kdfglellxegxdsjwk
```

(16 characters, no spaces)

But this likely won't work because Railway blocks SMTP ports entirely.

---

## 🎯 Why Resend?

- ✅ **Works on Railway** - Uses HTTPS API, not SMTP
- ✅ **Free tier** - 3,000 emails/month
- ✅ **Fast** - API is faster than SMTP
- ✅ **Reliable** - Better deliverability
- ✅ **Simple** - Just need API key
- ✅ **Already installed** - Package is ready

---

## 📊 Quick Start Commands

```bash
# After setting Railway variables, test:
curl https://stii-evote-production.up.railway.app/test-email.php

# Or visit in browser:
# https://stii-evote-production.up.railway.app/test-email.php
```

---

## 🔍 Verify It Works

After setup, the test should show:

```
✓ SMTP Connection Successful!
✓ Email Sent Successfully!
```

Check your inbox at rthrcapistrano@gmail.com for the test email.

---

**Date:** February 2, 2026
**Status:** Resend package installed, ready to configure
