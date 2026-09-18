# 把本地 Qt 工程同步到 GitHub（QtCourse 仓库）

> **当前进度**：GitHub 账号已注册（qiaomai487-spec），仓库已创建：
> <https://github.com/qiaomai487-spec/QtCourse>（私有），本地代码已推送完成。
> 下面第 1～4 步作为流程记录保留，以后只需要看第 6 步。

## 0. 准备情况

下面这些已经在电脑上装好了，无需重复操作：

- Git for Windows（`C:\Program Files\Git\cmd\git.exe`）
- GitHub CLI（`gh`，如果已安装，可用它登录并创建仓库）
- 本地仓库：`QtCourse`（已经 `git init`，并且有两次提交）

## 1. 注册 GitHub 账号

1. 打开 <https://github.com/signup>；
2. 填写邮箱、密码、用户名（用户名会出现在仓库地址里，例如 `https://github.com/用户名/QtCourse`）；
3. 到邮箱里点验证链接完成验证（**这一步必须本人操作**）；
4. 建议在 `Settings → Emails` 里勾选 “Keep my email addresses private”，
   这样推送时不会暴露真实邮箱。

## 2. 配置 Git 身份（只需做一次）

```bat
git config --global user.name "你的名字或昵称"
git config --global user.email "你的GitHub注册邮箱"
git config --global init.defaultBranch main
git config --global core.autocrlf true
```

## 3. 在 GitHub 上创建仓库

网页方式：打开 <https://github.com/new>，

- Repository name 填 `QtCourse`
- 选择 Public（公开）或 Private（私有）
- **不要**勾选 “Add a README file / .gitignore / license”（因为本地已经有内容了）
- 点 `Create repository`

## 4. 关联远程仓库并推送

在仓库目录（`QtCourse`）里打开命令行（右键 → 在终端中打开），执行：

```bat
git remote add origin https://github.com/你的用户名/QtCourse.git
git branch -M main
git push -u origin main
```

第一次推送会弹出登录窗口：

- 推荐选择 `Sign in with your browser`（浏览器登录）；
- 或者使用 **Personal Access Token**：到 `GitHub → Settings → Developer settings →
  Personal access tokens → Tokens (classic)` 生成一个带 `repo` 权限的 token，
  在密码位置粘贴这个 token（GitHub 已经不支持用账号密码推送）。

推送成功后刷新网页，就能看到工程文件和提交记录。

## 5. 用 GitHub CLI（gh）一步完成（可选，更省事）

```bat
gh auth login                     :: 按提示选择 GitHub.com → HTTPS → 浏览器登录
cd /d 仓库路径\QtCourse
gh repo create QtCourse --public --source . --remote origin --push
```

或者直接运行本文件夹里的 `connect_github.ps1`：

```bat
powershell -ExecutionPolicy Bypass -File connect_github.ps1 -GitHubUser 你的用户名
```

（脚本会自动完成“登录 → 创建远程仓库 → 推送”，不想公开仓库就再加 `-Private`。）

## 6. 以后每次修改后的同步流程

```bat
git status                        :: 看看改了哪些文件
git add -A                        :: 把所有修改加入暂存区
git commit -m "修改说明"            :: 提交到本地仓库
git push                          :: 推送到 GitHub
```

也可以直接双击本文件夹里的 `push_to_github.ps1`（右键 → 使用 PowerShell 运行），
脚本会自动完成“提交 + 推送”。

## 7. 常见问题

| 现象 | 原因与解决 |
| --- | --- |
| `fatal: not a git repository` | 当前目录不是仓库目录，先 `cd` 到 `QtCourse` 目录 |
| `remote origin already exists` | 已经加过远程仓库了，用 `git remote set-url origin 新地址` 修改 |
| `failed to push some refs` | 远程比本地新，先 `git pull --rebase` 再 `git push` |
| 推送时要求输入密码 | GitHub 不接受账号密码，改用浏览器登录或 Personal Access Token |
| `LF will be replaced by CRLF` | Windows 换行符提示，属于正常现象，可忽略 |
| 不想把 `*.pro.user` 传上去 | `.gitignore` 已经忽略它了，别用 `git add -f` 强制添加即可 |
