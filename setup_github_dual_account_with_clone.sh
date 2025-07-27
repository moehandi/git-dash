#!/bin/bash

# GitHub dual account setup with repo cloning

# === Configuration ===
PERSONAL_EMAIL="personal_email@gmail.com"
WORK_EMAIL="work_email@company.com"
PERSONAL_NAME="Personal Name"
WORK_NAME="Work Name"

# GitHub username dan repo
PERSONAL_USERNAME="username-personal"
WORK_USERNAME="username-work"
PERSONAL_REPO="personal-repo"
WORK_REPO="work-repo"

# Aliases SSH
PERSONAL_ALIAS="github-personal"
WORK_ALIAS="github-work"

# SSH Directory
SSH_DIR="$HOME/.ssh"

echo "===[ 🔧 Starting Setup Github Dual Account ]==="

# === Create SSH Keys ===
echo "📌 Generating SSH key for personal account..."
ssh-keygen -t ed25519 -C "$PERSONAL_EMAIL" -f "$SSH_DIR/id_rsa_personal" -N ""

echo "📌 Generating SSH key for work account..."
ssh-keygen -t ed25519 -C "$WORK_EMAIL" -f "$SSH_DIR/id_rsa_work" -N ""

# === Add to SSH agent ===
echo "🔑 Adding keys to SSH agent..."
eval "$(ssh-agent -s)"
ssh-add "$SSH_DIR/id_rsa_personal"
ssh-add "$SSH_DIR/id_rsa_work"

# === Create SSH configuration ===
echo "⚙️ Writing SSH configuration..."
cat <<EOF >> "$SSH_DIR/config"

# GitHub Personal
Host $PERSONAL_ALIAS
  HostName github.com
  User git
  IdentityFile $SSH_DIR/id_rsa_personal

# GitHub Work
Host $WORK_ALIAS
  HostName github.com
  User git
  IdentityFile $SSH_DIR/id_rsa_work
EOF

chmod 600 "$SSH_DIR/config"

# === Set Git Global Identity for personal account ===
echo "🔧 Setting Git global identity for personal account..."
git config --global user.name "$PERSONAL_NAME"
git config --global user.email "$PERSONAL_EMAIL"

# === Show public keys to add to GitHub ===
echo ""
echo "📎 Add the following public keys to your GitHub accounts:"
echo "➡️ Personal Account:"
cat "$SSH_DIR/id_rsa_personal.pub"
echo ""
echo "➡️ Work Account:"
cat "$SSH_DIR/id_rsa_work.pub"
echo ""

read -p "⏳ Already added GitHub? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "❗ Please add SSH key first in GitHub account."
    echo "Open: https://github.com/settings/keys"
    exit 1
fi

# === Clone Repositories ===
echo "📦 Cloning repo from GitHub..."
mkdir -p ~/github/personal ~/github/work

# Clone personal
git clone git@$PERSONAL_ALIAS:$PERSONAL_USERNAME/$PERSONAL_REPO.git ~/github/personal/$PERSONAL_REPO

# Clone work
git clone git@$WORK_ALIAS:$WORK_USERNAME/$WORK_REPO.git ~/github/work/$WORK_REPO

# === Set Git Identity for work account ===
cd ~/github/work/$WORK_REPO
git config user.name "$WORK_NAME"
git config user.email "$WORK_EMAIL"

echo ""
echo "✅ All Done!"
echo ""
echo "🗂️ Personal Repo in:  ~/github/personal/$PERSONAL_REPO"
echo "🗂️ Work Repo in:     ~/github/work/$WORK_REPO"
echo ""
echo "📌 Use:"
echo "git clone git@$PERSONAL_ALIAS:username/repo.git"
echo "git clone git@$WORK_ALIAS:username/repo.git"