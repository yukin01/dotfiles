# Polyglot runtime manager (asdf rust clone) — bootstrap の起点なので Brewfile 管理
brew "mise"
# Web browser (mise の cask shim が auto_updates + preflight を拒否するため brew 管理)
cask "firefox"
# Set of tools to manage resources and applications hosted on Google Cloud
# (.rc/functions の gcloud 補完が $(brew --prefix)/share/google-cloud-sdk に依存するため brew 管理)
cask "gcloud-cli"
# Terminal emulator that uses platform-native UI and GPU acceleration
cask "ghostty"
# Web browser (Keystone が root 所有ファイルを作り mise の入れ替えが毎回 sudo になるため brew 管理)
cask "google-chrome"
# Client for the Google Drive storage service (pkg + File Provider 統合が sudo 必須のため brew 管理)
cask "google-drive"
# Japanese input software
cask "google-japanese-ime"
# Software for Logitech devices
cask "logi-options+"
# Control your tools with a few keystrokes (アーカイブ内の app 解決に mise が失敗するため brew 管理)
cask "raycast"
# Video communication and virtual meeting platform (postflight が mise の cask shim で失敗するため brew 管理)
cask "zoom"
