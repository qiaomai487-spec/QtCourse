# 把本地 QtCourse 仓库连到 GitHub 并推送
#
# 用法（在 QtCourse\docs 目录里打开 PowerShell）：
#   powershell -ExecutionPolicy Bypass -File connect_github.ps1 -GitHubUser 你的用户名
#   powershell -ExecutionPolicy Bypass -File connect_github.ps1 -GitHubUser 你的用户名 -Private

param(
    [Parameter(Mandatory = $true)][string]$GitHubUser,
    [string]$RepoName = 'QtCourse',
    [switch]$Private
)

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot
Write-Host "仓库目录：$repoRoot" -ForegroundColor Cyan

$visibility = if ($Private) { '--private' } else { '--public' }
$gh = Get-Command gh -ErrorAction SilentlyContinue

if ($gh) {
    # 用 GitHub CLI：没登录就先登录，然后自动创建远程仓库并推送
    $loggedIn = (gh auth status 2>&1) -match 'Logged in'
    if (-not $loggedIn) {
        Write-Host '尚未登录 GitHub，请按提示完成浏览器登录……' -ForegroundColor Yellow
        gh auth login --hostname github.com --git-protocol https --web
    }
    Write-Host "正在创建仓库 $GitHubUser/$RepoName 并推送……" -ForegroundColor Cyan
    gh repo create "$GitHubUser/$RepoName" $visibility --source . --remote origin --push
} else {
    # 没有 gh：手工关联远程仓库后推送（需要先在网页上创建好空仓库）
    git remote remove origin 2>$null
    git remote add origin "https://github.com/$GitHubUser/$RepoName.git"
    git branch -M main
    Write-Host '首次推送会要求登录：可以选浏览器登录，或粘贴 Personal Access Token。' -ForegroundColor Yellow
    git push -u origin main
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "完成！仓库地址：https://github.com/$GitHubUser/$RepoName" -ForegroundColor Green
} else {
    Write-Host '推送失败：请确认 GitHub 上已创建同名空仓库、且已正确登录。' -ForegroundColor Red
}
