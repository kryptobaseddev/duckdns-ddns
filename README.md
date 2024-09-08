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

### 3. Prepare the `duck.sh` Script

The `duck.sh` script is used to update DuckDNS with your Raspberry Pi's external IP.

1. Make the `duck.sh` script executable by running the following command:
    ```bash
    chmod +x duck.sh
    ```

2. **Verify** that the `duck.sh` script is using the **hardcoded** DuckDNS domain and token (for now):
    ```bash
    nano duck.sh
    ```

    Ensure it looks something like this:

    ```bash
    #!/bin/bash

    # Perform the DuckDNS update
    echo "Updating DuckDNS for domain yourdomain"
    curl "https://www.duckdns.org/update?domains=yourdomain&token=6f247643-your-token-953bfe70a016&ip=" -k -o ~/duckdns-ddns/duckdns.log

    # Log the result
    echo "DuckDNS update complete. Log available at ~/duckdns-ddns/duckdns.log"
    ```

    Once confirmed, save the file (`CTRL + X`, then `Y`, and `Enter`).

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

---

### 8. How to Set a Static IP on Raspberry Pi

To ensure your Raspberry Pi keeps the same IP address on your network, you can configure a static IP address by editing the `dhcpcd.conf` file.

#### A. **Find the Current Network Information**
First, get your current network details by running:
```bash
ip addr show
```

#### B. **Edit the `dhcpcd.conf` File**
1. Open the `dhcpcd.conf` file for editing:
    ```bash
    sudo nano /etc/dhcpcd.conf
    ```
2. Scroll to the bottom of the file and add the following lines, replacing the values with your desired static IP, router IP (gateway), and DNS server:
    ```bash
    interface wlan0  # For Wi-Fi (use eth0 for Ethernet)
    static ip_address=10.0.0.138/24  # Your desired static IP and subnet mask
    static routers=10.0.0.1  # Your router's IP (gateway)
    static domain_name_servers=8.8.8.8 8.8.4.4  # Google's DNS or your preferred DNS
    ```
3. Save the file (`CTRL + X`, then `Y`, and `Enter`).

#### C. **Restart the Raspberry Pi**
- After saving the changes, restart your Raspberry Pi for the new static IP to take effect:
    ```bash
    sudo reboot
    ```

### D. Verify the Static IP
- After the Pi reboots, check if the static IP is set correctly by running:
    ```bash
    ip addr show
    ```

## Troubleshooting
- **Git Not Installed:** If you receive a “git command not found” error, install Git using the commands provided in the prerequisites section.
    - Install Git using the following commands:
        ```bash
        sudo apt update
        sudo apt install git
        ```
- **Permission Denied:** If you receive a “Permission Denied” error while running the `chmod +x duck.sh` command, ensure you’re running it with `sudo`.
- **SSH Permission Denied:** If you receive a "Permission Denied" error while trying to SSH into the Pi, double-check the IP address and credentials. Ensure that SSH is enabled and the correct password is being used.
    - You can enable SSH alternatively by creating an empty file named `ssh` in the boot partition of the SD card.
        - Once the file is created, insert the SD card back into the Pi and boot it up.
        - SSH should now be enabled, and you can connect to the Pi using the default credentials.
        - Remember to change the default password for security reasons.
        - If you need to keep SSH enabled, you can now run the `sudo systemctl enable ssh` command to ensure it starts on boot.
    - If you’ve set up a static IP, ensure you’re using the correct IP address to connect.
    - If you’re still unable to connect, try connecting via the local network first to troubleshoot.
    - If you’re using a firewall, ensure that the port you’re trying to connect to is open.
    - If you’re using a VPN, ensure that the VPN is not blocking the connection.
    - If you’re using a public Wi-Fi network, ensure that the network allows SSH connections.

## Future Improvements
- **Dynamic Domain and Token:** Implement a way to pass the DuckDNS domain and token as arguments to the script for better security using the `config.env` file.
- **Logging and Error Handling:** Add more detailed logging and error handling to the script for better troubleshooting.
- **User Input Validation:** Validate user input for the DuckDNS domain and token to prevent incorrect entries.
- **Custom Update Interval:** Allow users to set a custom update interval for the DuckDNS updater service.
- **Secure Communication:** Implement secure communication between the Raspberry Pi and DuckDNS for updating the IP address.
- **Web Interface:** Create a simple web interface to configure the DuckDNS updater settings and view logs.
- **Email Notifications:** Add email notifications for successful or failed IP updates to keep users informed.
- **Backup and Restore:** Implement a backup and restore feature for the DuckDNS updater settings and logs.