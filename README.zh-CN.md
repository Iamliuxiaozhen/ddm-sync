# ddm-sync

将 Linux 桌面环境中的显示器布局同步到已安装显示管理器的登录界面。

[English](README.md)

![ddm-sync 应用窗口](images/image.png)

## 功能

- 自动检测系统中可用的 SDDM、GDM3 和 GDM 同步目标。
- 仅同步当前系统实际存在的配置文件和显示管理器账户目录。
- 仅在需要写入 `/var/lib` 时通过 PolicyKit (`pkexec`) 请求授权。
- 清晰展示同步成功、失败或部分完成的结果。

## 支持的显示管理器

| 显示管理器 | 来源 | 目标 |
| --- | --- | --- |
| SDDM | `~/.local/share/kscreen` | `/var/lib/sddm/.local/share/kscreen` |
| GDM3 | `~/.config/monitors.xml` | `/var/lib/gdm3/.config/monitors.xml` |
| GDM | `~/.config/monitors.xml` | `/var/lib/gdm/.config/monitors.xml` |

## 环境要求

- `qmetaobject` 所需的 Qt/QML 运行时库。
- 用于向 `/var/lib` 写入配置的 `pkexec`。

在 Debian 或 Ubuntu 上，可使用以下命令安装构建依赖：

```bash
sudo apt-get install pkg-config qtbase5-dev qtdeclarative5-dev \
  qml-module-qtquick2 qml-module-qtquick-controls2
```

## 构建与运行

```bash
cargo build --release
./target/release/ddm-sync
```

仓库中的界面文件位于 `qml/Main.qml`。从发布压缩包运行时，请保持
`qml` 目录与 `ddm-sync` 可执行文件处于同一目录。

## GitHub Actions

推送到主分支和提交拉取请求时，工作流会执行构建、格式检查、静态检查和
测试，并上传构建得到的 Linux `ddm-sync` 可执行文件，工件名称为
`ddm-sync-linux-x86_64`。以 `v` 开头的版本标签会创建包含 Linux x86_64
可执行文件的 GitHub 草稿发布。

## 参与贡献

欢迎提交 Issue 和 Pull Request。提交前请保持改动聚焦，并运行：

```bash
cargo fmt -- --check
cargo clippy --locked -- -D warnings
cargo test --locked
```

## 许可证

本项目以 [MIT 许可证](LICENSE) 开源。
