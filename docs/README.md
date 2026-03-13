# Never Have I Ever - GitHub Pages Documentation

This directory contains the GitHub Pages website for Never Have I Ever.

## Files Included

- `index.html` - Main landing page
- `privacy.html` - Privacy policy
- `terms.html` - Terms and conditions
- `support.html` - Support and FAQ page

## Deployment Instructions

### Step 1: Push to GitHub

```bash
cd "/Users/chad/iOS Apps/Never Have I Ever"
git add docs/
git commit -m "Add GitHub Pages website with privacy policy and terms"
git push origin main
```

### Step 2: Enable GitHub Pages

1. Go to your repository: https://github.com/DiNerdyYawdie/Never-Have-I-Ever
2. Click on **Settings**
3. Scroll down to **Pages** in the left sidebar
4. Under **Source**, select:
   - Branch: `main`
   - Folder: `/docs`
5. Click **Save**

### Step 3: Wait for Deployment

GitHub will automatically build and deploy your site. This usually takes 1-2 minutes.

### Step 4: Access Your Site

Your website will be available at:
**https://dinerdyyawdie.github.io/Never-Have-I-Ever/**

## URLs for App Store Connect

Once deployed, use these URLs in App Store Connect:

- **Privacy Policy URL:**
  ```
  https://dinerdyyawdie.github.io/Never-Have-I-Ever/privacy.html
  ```

- **Terms & Conditions URL:**
  ```
  https://dinerdyyawdie.github.io/Never-Have-I-Ever/terms.html
  ```

- **Support URL:**
  ```
  https://dinerdyyawdie.github.io/Never-Have-I-Ever/support.html
  ```

- **Marketing URL (Home Page):**
  ```
  https://dinerdyyawdie.github.io/Never-Have-I-Ever/
  ```

## Custom Domain (Optional)

If you want to use a custom domain like `neverhaveiever.app`:

1. Purchase a domain from a registrar (Namecheap, Google Domains, etc.)
2. In your GitHub repository settings under Pages, add your custom domain
3. Add DNS records at your domain registrar:
   - Type: `CNAME`
   - Name: `www`
   - Value: `dinerdyyawdie.github.io`
4. Wait for DNS propagation (can take up to 48 hours)

## Updating the Website

To make changes:

1. Edit the HTML files in the `docs/` directory
2. Commit and push changes:
   ```bash
   git add docs/
   git commit -m "Update website content"
   git push origin main
   ```
3. GitHub Pages will automatically redeploy (takes 1-2 minutes)

## Important Notes

- Make sure the `docs/` folder is in your repository root
- All HTML files should use relative links to each other
- The privacy policy and terms are legally binding - review carefully before deploying
- Update the email address `support@neverhaveiever.app` to your actual support email

## Testing Locally

To test the website locally before deploying:

```bash
cd docs
python3 -m http.server 8000
```

Then open `http://localhost:8000` in your browser.
