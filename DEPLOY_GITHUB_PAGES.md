# Deploy GitHub Pages - Quick Guide

## What You're Deploying

A complete website with:
- Landing page (index.html)
- Privacy Policy (privacy.html)
- Terms & Conditions (terms.html)
- Support/FAQ (support.html)

## Step-by-Step Deployment

### 1. Push the docs folder to GitHub

```bash
cd "/Users/chad/iOS Apps/Never Have I Ever"
git add docs/
git commit -m "Add GitHub Pages website"
git push origin main
```

### 2. Enable GitHub Pages

1. Go to: https://github.com/DiNerdyYawdie/Never-Have-I-Ever/settings/pages
2. Under **Source**:
   - Branch: Select `main`
   - Folder: Select `/docs`
3. Click **Save**

### 3. Wait 1-2 Minutes

GitHub will build and deploy your site automatically.

### 4. Your Website URLs

Once deployed, your site will be live at:

**Main Site:**
```
https://dinerdyyawdie.github.io/Never-Have-I-Ever/
```

**Privacy Policy:**
```
https://dinerdyyawdie.github.io/Never-Have-I-Ever/privacy.html
```

**Terms & Conditions:**
```
https://dinerdyyawdie.github.io/Never-Have-I-Ever/terms.html
```

**Support Page:**
```
https://dinerdyyawdie.github.io/Never-Have-I-Ever/support.html
```

## Use These URLs in App Store Connect

Copy/paste these exact URLs into App Store Connect:

| Field | URL |
|-------|-----|
| **Privacy Policy URL** | `https://dinerdyyawdie.github.io/Never-Have-I-Ever/privacy.html` |
| **Support URL** | `https://dinerdyyawdie.github.io/Never-Have-I-Ever/support.html` |
| **Marketing URL** (optional) | `https://dinerdyyawdie.github.io/Never-Have-I-Ever/` |
| **Terms URL** (in app description) | `https://dinerdyyawdie.github.io/Never-Have-I-Ever/terms.html` |

## Important: Update Email Address

Before deploying, change the support email in all HTML files:

Find: `support@neverhaveiever.app`
Replace with: Your actual support email

Files to update:
- docs/privacy.html
- docs/terms.html
- docs/support.html

## Verify Deployment

After deployment, check that all pages load correctly:
1. Visit https://dinerdyyawdie.github.io/Never-Have-I-Ever/
2. Click all navigation links (Privacy, Terms, Support)
3. Verify content displays correctly

## That's It!

Your website is now live and ready for App Store submission. 🎉
