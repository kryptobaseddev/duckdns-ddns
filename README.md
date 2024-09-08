# DuckDNS Updater

This package will automatically update your DuckDNS domain with the current IP address of your Raspberry Pi. It’s designed to run as a service that starts on boot and regularly checks every 5 minutes to ensure the external IP is updated.

### Prerequisites

1. **Ensure your Raspberry Pi is connected to the internet** and has access to the terminal (either directly or via SSH).

2. **Install Git on your Raspberry Pi** (if it isn’t already installed). Run:
    ```bash
    sudo apt update
    sudo apt install git
    ```

### 1. SSH Into Your Raspberry Pi

If you are connecting to your Raspberry Pi from another computer, follow these steps to use SSH (Secure Shell).

#### A. **Enable SSH on the Raspberry Pi**
- If you haven’t enabled SSH yet, follow these steps:
    - Open the terminal on your Raspberry Pi or access it via a connected monitor and keyboard.
    - Run the following commands to enable SSH:
      ```bash
      sudo systemctl enable ssh
      sudo systemctl start ssh
      ```

#### B. **Find Your Raspberry Pi’s IP Address**
- Run this command to find the IP address of your Raspberry Pi:
    ```bash
    hostname -I
    ```
- Note down the IP address (it will look like `192.168.x.xxx`).

#### C. **SSH from Another Computer**
- Open the terminal on your other computer (or PuTTY if you’re on Windows).
- Use the following command, replacing `<raspberry-pi-ip>` with your Raspberry Pi’s IP address:
    ```bash
    ssh pi@<raspberry-pi-ip>
    ```
- Example: If your Pi’s IP is `192.168.1.100`, you’d run:
    ```bash
    ssh pi@192.168.1.100
    ```
- If this is your first time connecting, it will ask you to confirm the connection. Type `yes` and press Enter.
- Enter the password (default is `raspberry`, unless you’ve changed it).

### 2. Clone the DuckDNS Updater Repository

Once connected to your Raspberry Pi via SSH, you can clone the DuckDNS updater repository.

1. Run the following commands:
    ```bash
    git clone https://github.com/kryptobaseddev/duckdns-ddns.git
    cd duckdns-ddns
    ```

This will download the repository and switch to the `duckdns-ddns` directory.

### 3. Configure DuckDNS Domain and Token

You need to provide your DuckDNS token and domain in a configuration file.

1. Open the configuration file for editing:
    ```bash
    nano config.env
    ```

2. Inside the `nano` editor, you will see a blank file. Type or paste the following:

    ```bash
    TOKEN="your-duckdns-token"
    DOMAIN="your-domain"
    ```

    Replace `"your-duckdns-token"` with your actual DuckDNS token and `"your-domain"` with your DuckDNS domain name (e.g., `yourdomain`).

3. **How to Use Nano**:
    - To **save and exit**:
      - Press `CTRL + X` to exit.
      - Press `Y` to confirm saving.
      - Press `Enter` to confirm the filename (`config.env`).

Now your DuckDNS configuration is ready.

### 4. Install the Service

We will now install the DuckDNS updater as a systemd service so it runs on boot.

1. Copy the service file to the systemd folder:
    ```bash
    sudo cp duckdns.service /etc/systemd/system/
    ```

2. Reload the systemd daemon to recognize the new service:
    ```bash
    sudo systemctl daemon-reload
    ```

3. Enable the service to start automatically on boot:
    ```bash
    sudo systemctl enable duckdns.service
    ```

4. Start the DuckDNS service manually for the first time:
    ```bash
    sudo systemctl start duckdns.service
    ```

To check the status of the service at any time, you can use:
    ```bash
    sudo systemctl status duckdns.service
    ```
### 5. (Optional) Install a Timer for Scheduled Updates
If you prefer to use a systemd timer instead of cron for updating your IP every 5 minutes, you can set up a timer.

1. Copy the timer file to the systemd folder:
    ```bash
    sudo cp duckdns.timer /etc/systemd/system/
    ```

2. Reload the systemd daemon:
    ```bash
    sudo systemctl daemon-reload
    ```

3. Enable the timer to start on boot:
    ```bash
    sudo systemctl enable duckdns.timer
    ```

4. Start the timer:
    ```bash
    sudo systemctl start duckdns.timer
    ```

This will ensure the DuckDNS updater runs every 5 minutes to check and update the external IP address.

### 6. Configure Router for Remote Access
To access your Raspberry Pi from outside your local network (e.g., from the internet), you will need to set up port forwarding on your router.

#### A. Access Your Router Settings
- Open a browser and enter your router’s IP address (usually `192.168.1.1` or `192.168.0.1`).
- Log in with your router’s credentials.

#### B. Set Up Port Forwarding
1. Find the **Port Forwarding** section in your router's settings (it may be under “Advanced” or “NAT”).
2. Add a new forwarding rule:
   - **External Port**: Choose a port for accessing your Pi remotely (e.g., 8080 for HTTP, 22 for SSH).
   - **Internal IP Address**: Enter your Pi’s local IP (e.g., `192.168.1.100`).
   - **Internal Port**: Match the internal port with the external one (e.g., 80 for HTTP or 22 for SSH).
   - **Protocol**: Select `TCP` or `Both`.

#### C. Save Changes
After configuring the port forwarding, save the settings. You can now access your Pi from anywhere using your DuckDNS domain (e.g., `yourdomain.duckdns.org:8080` or `yourdomain.duckdns.org:22`).

### 7. Testing Remote Access
To test if everything is working, try accessing your Raspberry Pi from outside your network using your DuckDNS domain. If you’ve forwarded SSH (port 22), for example:

    ```bash
    ssh pi@yourdomain.duckdns.org -p 22
    ```

## Troubleshooting
- Git Not Installed: If you receive an error saying git: command not found, you may need to install Git by running:
    ```bash
    sudo apt update
    sudo apt install git
    ```

- SSH Permission Denied: If you receive a "Permission Denied" error while trying to SSH into the Pi, double-check the IP address and credentials. Ensure that SSH is enabled and the correct password is being used.