# 一键把本次修改提交并推送到 GitHub
# 用法：在仓库目录里右键 → “使用 PowerShell 运行”，或
#       powershell -ExecutionPolicy Bypass -File push_to_github.ps1 "提交说明"

param(
    [string]$Message = "更新实验代码"
)

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

Write-Host "仓库目录：$repoRoot" -ForegroundColor Cyan

if (-not (Test-Path (Join-Path $repoRoot '.git'))) {
    Write-Host "这里不是 Git 仓库，请确认脚本放在 QtCourse\docs 目录下。" -ForegroundColor Red
    exit 1
}

$remote = git remote get-url origin 2>$null
if (-not $remote) {
    Write-Host "还没有配置远程仓库，请先执行：" -ForegroundColor Yellow
    Write-Host '  git remote add origin https://github.com/你的用户名/QtCourse.git'
    exit 1
}
Write-Host "远程仓库：$remote" -ForegroundColor Cyan

git add -A
$changes = git status --porcelain
if ($changes) {
    git commit -m $Message
} else {
    Write-Host "没有新的改动需要提交。" -ForegroundColor Yellow
}

git push
if ($LASTEXITCODE -eq 0) {
    Write-Host "推送成功！" -ForegroundColor Green
} else {
    Write-Host "推送失败，请检查网络或登录状态（gh auth login）。" -ForegroundColor Red
}
