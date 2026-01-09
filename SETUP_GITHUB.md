# Setup Instructions for Public GitHub Repository

## Step 1: Authenticate GitHub CLI (if not already done)

Run this command in your terminal:
```bash
gh auth login
```

Follow the prompts to authenticate with GitHub.

## Step 2: Create and Push the Public Repository

Once authenticated, run this command from the `claude-config-public` directory:

```bash
cd claude-config-public
gh repo create claude-config-public --public --source=. --remote=origin --push
```

## Alternative: Manual GitHub Setup

If you prefer to create the repository manually:

1. Go to https://github.com/new
2. Repository name: `claude-config-public`
3. Description: "Public repository containing Claude AI configuration files"
4. Set to **Public**
5. **Do NOT** initialize with README, .gitignore, or license (we already have files)
6. Click "Create repository"

Then run these commands:
```bash
cd claude-config-public
git remote add origin https://github.com/YOUR_USERNAME/claude-config-public.git
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## After Setup

Once the repository is created and pushed, you can share the public URL with Grok:
`https://github.com/YOUR_USERNAME/claude-config-public`
