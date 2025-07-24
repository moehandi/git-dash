#!/bin/bash

# Basic GitHub dual account setup script

# === Configuration ===
PERSONAL_EMAIL="personal_email@gmail.com"
WORK_EMAIL="work_email@company.com"
PERSONAL_NAME="Personal Name"
WORK_NAME="Work Name"
PERSONAL_ALIAS="github-personal"
WORK_ALIAS="github-work"
SSH_DIR="$HOME/.ssh"

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

# === Show public keys to add to GitHub ===
echo ""
echo "📎 Add the following public keys to your GitHub accounts:"
echo "➡️ Personal Account:"
cat "$SSH_DIR/id_rsa_personal.pub"
echo ""
echo "➡️ Work Account:"
cat "$SSH_DIR/id_rsa_work.pub"
echo ""

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

# === Final message ===
echo ""
echo "✅ Done! SSH and Git are ready for 2 GitHub accounts."
echo ""
echo "👉 Next steps:"
echo "- Add the public keys above to each GitHub account."
echo "- When cloning a repo:"
echo "  📦 git clone git@$PERSONAL_ALIAS:username-personal/repo.git"
echo "  📦 git clone git@$WORK_ALIAS:username-work/repo.git"
echo ""
echo "🔁 For work repos, set local identity:"
echo "  git config user.name \"$WORK_NAME\""
echo "  git config user.email \"$WORK_EMAIL\""