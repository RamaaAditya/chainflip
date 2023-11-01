#!/bin/bash
echo "Input your detail here: "
    read -p "Input your IP Address: " IP_address
    read -p "Input your Https API: " https_endpoint
    read -p "Input your WSS API: " wss_endpoint
    {
sudo systemctl stop chainflip-engine0.10
sudo rm -rf /etc/chainflip/config/Settings.toml
sudo tee  /etc/chainflip/config/Settings.toml > /dev/null <<EOF
# Default configurations for the CFE
[node_p2p]
node_key_file = "/etc/chainflip/keys/node_key_file"
ip_address = "$IP_address"
port = "8078"

[state_chain]
ws_endpoint = "ws://127.0.0.1:9944"
signing_key_file = "/etc/chainflip/keys/signing_key_file"

[eth]
# Ethereum private key file path. This file should contain a hex-encoded private key.
private_key_file = "/etc/chainflip/keys/ethereum_key_file"

[eth.rpc]
ws_endpoint = "$https_endpoint"
http_endpoint = "$wss_endpoint"

#optional
# [eth.backup_rpc]
# ws_endpoint = "wss://some_public_rpc.com:443/<secret_access_key>"
# http_endpoint = "https://some_public_rpc.com:443/<secret_access_key>"

[dot.rpc]
ws_endpoint = "wss://rpc-pdot.chainflip.io:443"
http_endpoint = "https://rpc-pdot.chainflip.io:443"

# [dot.backup_rpc]
# ws_endpoint = "wss://rpc-pdot2.chainflip.io:443"
# http_endpoint = "https://rpc-pdot2.chainflip.io:443"

[btc.rpc]
basic_auth_user = "flip"
basic_auth_password = "flip"
http_endpoint = "http://a108a82b574a640359e360cf66afd45d-424380952.eu-central-1.elb.amazonaws.com"

# [btc.backup_rpc]
# basic_auth_user = "flip2"
# basic_auth_password = "flip2"
# http_endpoint = "http://second-node-424380952.eu-central-1.elb.amazonaws.com"

[signing]
db_file = "/etc/chainflip/data.db"
EOF

sudo systemctl start chainflip-engine0.10
  }
