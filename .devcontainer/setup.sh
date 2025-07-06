#!/bin/bash

IFS=$' \n\t'

echo "🔥 Running OP Setup - Performance Mode ON..."

apt update && apt install -y python3-venv tlp unzip jq && apt clean && rm -rf /var/lib/apt/lists/*

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
systemctl restart zramswap
systemctl start docker
systemctl enable tlp && systemctl start tlp

npm install -g npm yarn pm2

echo '* soft nofile 1048576' | tee -a /etc/security/limits.conf
echo '* hard nofile 1048576' | tee -a /etc/security/limits.conf
ulimit -n 1048576

cd "/workspaces/naxus-"

scripts=(
  "https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/gh_installer.sh"
  "https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/megen.sh"
  "https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/mega.sh"
  "https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/mega_downloader.sh"
  "https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/nexus.sh"
)

echo "📥 Downloading all scripts..."

# Store filenames in an array
filenames=()

for url in "${scripts[@]}"; do
  filename=$(basename "$url")
  echo "⬇️ Downloading $filename..."
  curl -sSLO "$url"
  filenames+=("$filename")
done

echo "✅ All scripts downloaded!"

echo "🔓 Making downloaded scripts executable..."
for file in "${filenames[@]}"; do
  chmod +x "$file"
done

echo "🎉 All scripts are downloaded & ready! Run them manually when needed."

# install gh cli

echo "installing gh cli"

bash gh_installer.sh


echo "📝 Checking for MEGA_CREDENTIALS in Codespace secrets..."

if [[ -n "${MEGA_CREDENTIALS:-}" ]]; then
  echo "✅ MEGA_CREDENTIALS found! Making mega.env..."
  bash megen.sh
  echo "🎉 mega.env created successfully!"
else
  echo "⚠️ MEGA_CREDENTIALS not found! Skipping mega.env creation."
fi

# Function to check env & run script
run_if_env_exists() {
  local ENV_FILE="$1"
  local SCRIPT="$2"

  if [[ -f "$ENV_FILE" ]]; then
    echo "✅ $ENV_FILE found! Running $SCRIPT..."
    bash "$SCRIPT"
    echo "🎉 $SCRIPT completed with exit code $?"
  else
    echo "⚠️ $ENV_FILE not found! Skipping $SCRIPT..."
  fi
}

# List of env-script pairs
declare -a tasks=(
  "mega.env mega.sh"
  "mega.env mega_downloader.sh"
  "og.env ognode.sh"
  "pop.env pipe.sh"
)

# Loop through each task (now IFS includes space, so split works)
for pair in "${tasks[@]}"; do
  read -r envfile script <<< "$pair"
  run_if_env_exists "$envfile" "$script"
done


#pull image for browser
docker pull  rohan014233/thorium

#run script for browser either restores it or makes new 

echo "Browsser is starting"

curl -sSLO https://raw.githubusercontent.com/naksh-07/Browser-Backup-Restore/refs/heads/main/restore.sh && bash restore.sh


#run nexus container
# bash nexus.sh

