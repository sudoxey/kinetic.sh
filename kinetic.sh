#!/bin/bash

# ------------------------------
# notice <blue|green|red> <text>
# ------------------------------

notice() {
    deliminator_top="!"
    deliminator_bottom="¡"
    if [ $1 = 'red' ]; then
        echo -e "\n$(tput setaf 1)$(tput bold)$(for each in $(seq 1 ${#2}); do printf $deliminator_top; done)\n$2\n$(for each in $(seq 1 ${#2}); do printf $deliminator_bottom; done)$(tput init)\n"
    elif [ $1 = 'green' ]; then
        echo -e "\n$(tput setaf 2)$(tput bold)$(for each in $(seq 1 ${#2}); do printf $deliminator_top; done)\n$2\n$(for each in $(seq 1 ${#2}); do printf $deliminator_bottom; done)$(tput init)\n"
    elif [ $1 = 'blue' ]; then
        echo -e "\n$(tput setaf 4)$(tput bold)$(for each in $(seq 1 ${#2}); do printf $deliminator_top; done)\n$2\n$(for each in $(seq 1 ${#2}); do printf $deliminator_bottom; done)$(tput init)\n"
    fi
}

# --------------
# tweaking gnome
# --------------

notice "blue" "tweaking gnome..."
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface show-battery-percentage 'true'
# gsettings set org.gnome.desktop.peripherals.mouse natural-scroll 'true'
gsettings set org.gnome.desktop.privacy hide-identity 'true'
gsettings set org.gnome.desktop.privacy old-files-age 'uint32 0'
gsettings set org.gnome.desktop.privacy recent-files-max-age '1'
gsettings set org.gnome.desktop.privacy remember-app-usage 'false'
gsettings set org.gnome.desktop.privacy remember-recent-files 'false'
gsettings set org.gnome.desktop.privacy remove-old-temp-files 'true'
gsettings set org.gnome.desktop.privacy remove-old-trash-files 'true'
gsettings set org.gnome.desktop.privacy report-technical-problems 'false'
gsettings set org.gnome.desktop.privacy show-full-name-in-top-bar 'false'
gsettings set org.gnome.desktop.session idle-delay '0'
gsettings set org.gnome.mutter center-new-windows 'true'
gsettings set org.gnome.nautilus.preferences show-create-link 'true'
gsettings set org.gnome.nautilus.preferences show-delete-permanently 'true'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'nothing'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts 'false'
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash 'false'
gsettings set org.gnome.shell.extensions.ding show-home 'false'
gsettings set org.gnome.shell favorite-apps '["org.gnome.Terminal.desktop", "org.gnome.Nautilus.desktop"]'
notice "green" "tweaking gnome done..."

# -------------
# updating grub
# -------------
# not recommended for multiple operating systems

notice "blue" "updating grub..."
sudo tee -a '/etc/default/grub' > /dev/null <<< 'GRUB_RECORDFAIL_TIMEOUT=0'
sudo update-grub
notice "green" "updating grub done..."

# ----------------------------
# purging default applications
# ----------------------------

notice "blue" "purging default applications..."
sudo apt autoremove --purge -y \
    apport \
    eog \
    file-roller \
    firefox \
    gnome-calculator \
    gnome-characters \
    gnome-disk-utility \
    gnome-font-viewer \
    gnome-logs \
    gnome-power-manager \
    gnome-startup-applications \
    gnome-system-monitor \
    gnome-text-editor \
    libevdocument3-4 \
    seahorse \
    ubuntu-report \
    vim-common \
    whoopsie \
    yelp
sudo snap remove firefox
notice "green" "purging default applications done..."

# -----------------
# hiding menu icons
# -----------------

notice "blue" "hiding menu icons..."
cp \
    '/usr/share/applications/im-config.desktop' \
    '/usr/share/applications/gnome-language-selector.desktop' \
    '/usr/share/applications/nm-connection-editor.desktop' \
    '/usr/share/applications/org.gnome.Settings.desktop' \
    '/var/lib/snapd/desktop/applications/snap-store_ubuntu-software.desktop' \
    '/usr/share/applications/software-properties-drivers.desktop' \
    "$HOME/.local/share/applications"
tee -a \
    "$HOME/.local/share/applications/im-config.desktop" \
    "$HOME/.local/share/applications/gnome-language-selector.desktop" \
    "$HOME/.local/share/applications/nm-connection-editor.desktop" \
    "$HOME/.local/share/applications/org.gnome.Settings.desktop" \
    "$HOME/.local/share/applications/snap-store_ubuntu-software.desktop" \
    "$HOME/.local/share/applications/software-properties-drivers.desktop" \
    <<< 'Hidden=true' > /dev/null
notice "green" "hiding menu icons done..."

# ---------------
# updating system
# ---------------
notice "blue" "updating system..."
sudo apt update
notice "green" "updating system done..."

# ----------------
# upgrading system
# ----------------

notice "blue" "upgrading system..."
sudo apt full-upgrade -y
notice "green" "upgrading system done..."

# ------------------
# installing flatpak
# ------------------

notice "blue" "installing flatpak..."
sudo apt install -y \
    flatpak \
    gnome-software-plugin-flatpak
notice "green" "installing flatpak done..."

# -------------------------------
# installing flathub applications
# -------------------------------

notice "blue" "installing flathub applications..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y com.google.Chrome
# flatpak install flathub -y \
#     com.google.Chrome \
#     com.mattjakeman.ExtensionManager \
#     io.github.davidoc26.wallpaper_selector \
#     org.gnome.Calculator \
#     org.gnome.Calendar \
#     org.gnome.eog \
#     org.gnome.FileRoller \
#     org.gnome.Rhythmbox3 \
#     org.gnome.TextEditor \
#     org.gnome.Totem
notice "green" "installing flathub applications done..."

# -------------
# house keeping
# -------------

notice "blue" "house keeping..."
rm -rf .wget-hsts
sudo apt clean
sudo apt autoclean &> /dev/null
sudo apt autoremove --purge -y &> /dev/null
gsettings reset org.gnome.shell app-picker-layout
notice "green" "house keeping done..."

# ---------
# rebooting
# ---------

notice "green" "kinectic.sh has been installed..."
notice "red" "Rebooting in 10 seconds..."
notice "blue" "Press CTRL+C to reboot manually..."
sleep 10
sudo reboot
