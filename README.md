# GitHub Dual Account Setup

This project provides a simple Bash script, `setup_github_dual_accounts.sh`, to help you configure and switch between two GitHub accounts (e.g., personal and work) on a single Linux machine using SSH and Git identity.

## Contents

`setup_github_dual_accounts.sh` Automates the setup of two separate GitHub accounts by:
  - Generating SSH keys for each account
  - Adding the keys to the SSH agent
  - Displaying public keys for easy addition to GitHub
  - Writing an SSH config for seamless switching
  - Setting your global Git identity for the personal account
  - Providing instructions for cloning and configuring repositories for each account

## Usage
1. **Save as a file:**  
  `setup_github_dual_accounts.sh`

2. **Make it executable:**
    ```bash
    chmod +x setup_github_dual_accounts.sh
    ```
3. Run the script:
    ```bash
    bash setup_github_dual_accounts.sh
    ```
    or

    ```bash
    ./setup_github_dual_accounts.sh
    ```

4. Add the generated public keys to your respective GitHub accounts (personal and work). Add SSH Key to Github ([https://github.com/settings/keys](https://github.com/settings/keys))
5. Follow the instructions printed by the script to clone repositories and set local Git identity for work repos if needed.

## Notes

- The script is intended for Linux systems.
- You can customize the email addresses, names, and aliases at the top of the script.
- Never share id_rsa_* (private key) files with anyone.
- For extra security, add a passphrase when generating keys.
---
Feel free to modify the script to suit your workflow or add more accounts as needed.