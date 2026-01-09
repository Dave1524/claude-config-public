# PowerShell script to set up the public GitHub repository
# Run this script after authenticating with GitHub CLI

Write-Host "Setting up public GitHub repository..." -ForegroundColor Green

# Check if gh is authenticated
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "GitHub CLI is not authenticated. Please run: gh auth login" -ForegroundColor Yellow
    exit 1
}

# Create public repository and push
Write-Host "Creating public repository 'claude-config-public'..." -ForegroundColor Cyan
gh repo create claude-config-public --public --source=. --remote=origin --push

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nSuccess! Repository created and pushed." -ForegroundColor Green
    Write-Host "You can now access it at: https://github.com/$(gh api user --jq .login)/claude-config-public" -ForegroundColor Cyan
} else {
    Write-Host "`nError creating repository. Please check the error message above." -ForegroundColor Red
}
