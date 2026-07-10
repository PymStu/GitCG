# GitCG - GitHub Contribution Wall

自动刷 GitHub 贡献墙的脚本，每天随机提交 3-7 次，让贡献图保持绿色。

## 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/PymBlog/GitCG.git
cd GitCG

# 2. 登录 GitHub CLI（首次使用需要）
gh auth login

# 3. 一键配置定时任务
bash setup.sh

# 4. 手动测试一次
bash contribute.sh
```

## 工作原理

GitHub 贡献图统计的是 commit 次数，不管内容。脚本利用这一点：

1. systemd timer 每天 08:00-22:00 随机触发
2. 每次运行写入 3-7 条随机哈希到 `contributions.txt`
3. 提交并 push 到 GitHub
4. GitHub 显示为绿色贡献方块

## 自定义

### 修改提交时间范围

编辑 `setup.sh` 中的 `OnCalendar` 行：

```
# 早8点到晚10点
OnCalendar=*-*-* 08,09,10,11,12,13,14,15,16,17,18,19,20,21,22:00

# 全天24小时
OnCalendar=*-*-* 00,01,02,...,23:00
```

修改后重新运行 `bash setup.sh`。

### 修改每日提交次数

编辑 `contribute.sh` 中的：

```bash
COMMIT_COUNT=$((RANDOM % 5 + 3))  # 3-7次
# 改为 5-10次:
COMMIT_COUNT=$((RANDOM % 6 + 5))
```

## 常用命令

```bash
# 查看定时器状态
systemctl --user status github-contribute.timer

# 查看日志
cat .contribute.log

# 手动运行
bash contribute.sh

# 停用定时任务
systemctl --user disable --now github-contribute.timer
```

## 依赖

- [GitHub CLI (gh)](https://cli.github.com/) — 用于认证和推送
- systemd — Linux 定时任务服务（大部分发行版自带）
