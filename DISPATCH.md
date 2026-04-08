# D4JSP WordPress Multisite — Dispatch Instructions
# For Claude Code on ROG Ally

## SITUATION BRIEF
This is a FRESH Hostinger shared hosting server. There is NO WordPress installed yet.
The live D4JSP Next.js trading app runs separately at lawngreen-dinosaur-928580.hostingersite.com.
This WordPress install is a NEW project — a separate SEO landing network sitting alongside it.

You are building:
- A fresh WordPress Multisite install on d4jsp.org
- 7 additional subsites mapped to separate domains
- A gothic dark theme matching the D4JSP app design
- Under construction pages with full SEO on every site
- A GitHub repo with auto-deploy to Hostinger on every push

You have full control. Run the scripts in order. Ask for Hostinger SSH credentials
and DB credentials from the user before starting if you don't have them.


## What This Is
Full WordPress Multisite install for the D4JSP network.
- Main hub: d4jsp.org
- 7 subsites: diablo4mods/marketplace/exploits/guides/tools/clans/calculator.com
- 301s: d4mods.com → diablo4mods.com, d4marketplace.com → diablo4marketplace.com
- Theme: Gothic dark, matches D4JSP design system exactly
- All pages: Under Construction with perfect SEO per domain

---

## HOSTINGER SERVER DETAILS
- Domain:      d4jsp.org
- IP:          82.29.193.20
- Preview URL: lightsalmon-marten-733948.hostingersite.com
- Admin email: adam87lewis@gmail.com
- WP admin user: cowking
- SSH port:    65002 (standard Hostinger)
- SSH command: ssh YOUR_USER@82.29.193.20 -p 65002
  (find YOUR_USER in Hostinger panel → SSH Access)

## BEFORE YOU RUN ANYTHING
1. SSH in and run: echo $HOME  — that's the base of your WP_ROOT
2. WP_ROOT will be: $HOME/domains/d4jsp.org/public_html
3. Go to Hostinger panel → Databases → MySQL → Create new DB
   Note the DB name, user, and password — you'll need them for install.sh
4. Check WP-CLI: wp --info
   If missing: curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

---

## YOUR STARTING POINT
The zip has already been extracted. All files are at:
C:\Users\Owner\D4JSP-WP\d4jsp-wp\

## EXECUTION ORDER

### Step 1 — Open terminal in the project folder
```bash
cd C:\Users\Owner\D4JSP-WP\d4jsp-wp
```

### Step 2 — SSH into Hostinger to get your username and WP path
```bash
ssh YOUR_USER@82.29.193.20 -p 65002
echo $HOME
# Note the output — WP_ROOT will be: $HOME/domains/d4jsp.org/public_html
exit
```

### Step 3 — Edit install.sh with your credentials
Open scripts/install.sh and fill in:
- WP_ROOT (from step 2)
- DB_NAME, DB_USER, DB_PASS (create in Hostinger panel → Databases → MySQL first)
- ADMIN_PASS (pick a strong password)

### Step 4 — Upload package to server
```bash
scp -P 65002 -r . YOUR_USER@82.29.193.20:~/d4jsp-wp/
```

### Step 5 — SSH in and run install
```bash
ssh YOUR_USER@82.29.193.20 -p 65002
cd ~/domains/d4jsp.org/public_html
bash ~/d4jsp-wp/scripts/install.sh
```

### Step 4 — Copy .htaccess
```bash
cp .htaccess.dist .htaccess
# (wp core install may have written one — merge if needed)
```

### Step 5 — Run post-install
```bash
bash scripts/post-install.sh
```

### Step 6 — Upload theme
Theme lives in: `theme/d4jsp-dark/`
Copy to: `wp-content/themes/d4jsp-dark/`
```bash
cp -r theme/d4jsp-dark wp-content/themes/
```

### Step 7 — Domain Mapping
In WordPress Network Admin (/wp-admin/network/):
- Sites > Each site > Edit > Set domain to mapped domain
- Activate Mercator plugin network-wide
- Confirm sunrise.php is in wp-content/

### Step 8 — SSL
In Hostinger panel, enable SSL for each addon domain.

---

## FILE MAP
```
d4jsp-wp/
├── scripts/
│   ├── install.sh          ← WP-CLI full install
│   ├── post-install.sh     ← Creates pages, sets front page
│   └── sunrise.php         ← Domain mapping hook
├── theme/d4jsp-dark/
│   ├── style.css           ← Gothic dark design system
│   ├── functions.php       ← SEO meta per domain, enqueues
│   ├── header.php          ← Sticky header
│   ├── footer.php          ← Footer + mobile nav JS
│   ├── index.php           ← Default fallback
│   └── page-construction.php ← Under construction template
├── .htaccess               ← Multisite rewrites + 301s
└── DISPATCH.md             ← This file
```

---

## NOTES
- Hostinger SSH port is usually 65002
- WP-CLI should be available at `/usr/local/bin/wp`
  If not: `curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp`
- All SEO meta (og, twitter, JSON-LD, robots, canonical) is built into functions.php — no plugin needed for basic SEO
- Yoast is installed for sitemap generation only
