# DuckDNS Updater

This package will automatically update your DuckDNS domain with the current IP address of your Raspberry Pi.

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/kryptobaseddev/duckdns-ddns.git
    cd duckdns-dns
    ```

2. Configure your DuckDNS domain and token:
    ```bash
    nano config.env
    ```

3. Install the service:
    ```bash
    sudo cp duckdns.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable duckdns.service
    sudo systemctl start duckdns.service
    ```

4. (Optional) Install the timer for scheduled updates:
    ```bash
    sudo cp duckdns.timer /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable duckdns.timer
    sudo systemctl start duckdns.timer
    ```

5. Set up port forwarding on your router for remote access.
- Ensure your router is set up to forward traffic from the outside world to your Raspberry Pi by doing the following:

- Access your router settings and set up port forwarding for the desired port (HTTP, SSH, etc.).
- Forward external traffic on a specific port (e.g., 8080) to your Raspberry Pi’s internal IP address (e.g., 192.168.1.10) and the corresponding internal port (e.g., 80 or 22 for SSH).

Note: make sure to have Git installed so when you ssh into the device you can clone the repository.
use the following command to install git:
```bash
sudo apt update
sudo apt install git
```