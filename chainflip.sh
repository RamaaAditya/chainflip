#!/bin/bash

# the function is for showing progress bar
show_progress() {
    local total_steps=$1
    local current_step=0

    while [ $current_step -le $total_steps ]; do
        echo -ne "Processing: ${current_step}%\r"
        sleep 0.5
        ((current_step+=5))
    done
    echo -ne "Installation complete: 100%\n"
}

echo -p "
░█████╗░██╗░░██╗░█████╗░██╗███╗░░██╗███████╗██╗░░░░░██╗██████╗░
██╔══██╗██║░░██║██╔══██╗██║████╗░██║██╔════╝██║░░░░░██║██╔══██╗
██║░░╚═╝███████║███████║██║██╔██╗██║█████╗░░██║░░░░░██║██████╔╝
██║░░██╗██╔══██║██╔══██║██║██║╚████║██╔══╝░░██║░░░░░██║██╝░
╚█████╔╝██║░░██║██║░░██║██║██║░╚███║██║░░░░░███████╗██║██║░░░░░
░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚══╝╚═╝░░░░░╚═══  @RamaAditya"

echo "Choose what do you want:"
echo "1. Fix Chainflip"
echo "2. Auto Sync Installation"
echo "3. Upgrade the node ( CFE Version )"
echo "4. Rotate your node"
echo "5. Change your vanity name"
echo "6. Restart the node and the engine"
echo "7. Check logs"
echo "8. Recovery your pharse"
read -p "Your choice: " choice

case $choice in
  1)
    # Step 1: Install System
    {
        sudo systemctl stop chainflip-node > /dev/null 2>&1
        sudo systemctl stop chainflip-engine > /dev/null 2>&1
        sudo rm -rf /lib/systemd/system/chainflip-node.service
        sudo rm -rf /etc/chainflip/perseverance.chainspec.json
        sudo rm -rf /etc/chainflip/chaindata
        sudo apt install git > /dev/null 2>&1
        sudo git clone https://github.com/RamaaAditya/chainflip-0.9.git > /dev/null 2>&1
        sudo cp -r ./chainflip-0.9/chainflip-node.service /lib/systemd/system/
        sudo cp -r ./chainflip-0.9/perseverance.chainspec.json /etc/chainflip/
        sudo rm -rf ./chainflip-0.9
        sudo systemctl daemon-reload > /dev/null 2>&1
        sudo systemctl start chainflip-node > /dev/null 2>&1
        sudo systemctl -f -u chainflip-engine > /dev/null 2>&1
    } & show_progress 100

echo "All Installations Were Already done!, you can check your node
      by execute this command below
      sudo journalctl -f -u chainflip-*
        "
    ;;


  2)
    #For Auto Sync Installation
    echo "Running Auto Sync Installation..."
    {
        sudo systemctl stop chainflip-node
        sudo systemctl stop chainflip-engine
        sudo rm -rf /lib/systemd/system/chainflip-node.service
        sudo rm -rf /etc/chainflip/chaindata
        sudo apt install git > /dev/null 2>&1
        sudo git clone https://github.com/RamaaAditya/chainflip-0.9.git > /dev/null 2>&1
        sudo cp -r ./chainflip-0.9/chainflip-node.service /lib/systemd/system/
        sudo rm -rf ./chainflip-0.9
        sudo systemctl daemon-reload
        sudo systemctl start chainflip-node
        sudo systemctl -f -u chainflip-engine

    } & show_progress 100

    echo "Auto Sync Installation was already done."
    ;;

    3)
    # For Update Chainflip version 0.8 -> 0.9
    {
        sudo systemctl stop chainflip-node
        sudo systemctl stop chainflip-engine
        sudo rm /etc/apt/sources.list.d/chainflip.list
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/chainflip.gpg] https://repo.chainflip.io/perseverance/$(lsb_release -c -s) $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/chainflip.list
        sudo apt update > /dev/null/ 2>&1
        sudo apt --only-upgrade install "chainflip-*" > /dev/null/ 2>&1
        sudo systemctl start chainflip-node
        sudo systemctl start chainflip-engine
    } & show_progress 100

    echo "Update to 0.9 Already done .."

    ;;

    4)
    # Rotate node
    {
        sudo chainflip-cli --config-root /etc/chainflip rotate
    } 

    ;;

    5)
    # to change vanity name
    echo "Input your vanity name ( highly recomended to use your discord name )"
    read -p "Input your vanity name: " vanity
    {

        sudo chainflip-cli --config-root /etc/chainflip vanity-name $vanity

    }

    ;;

    6)
    #to restart the node & the engine
    {
        sudo systemctl restart chainflip-node
        sudo systemctl restart chainflip-engine
    } & show_progress 100

    echo "Restart already done"
    ;;


    7)
    # to check logs
    {
        sudo journalctl -f -u chainflip-*
    }

    ;;

    8)
    {
      chainflip-node key inspect "0x$(sudo cat /etc/chainflip/keys/signing_key_file)"
    }
    ;;


      *)
    echo "Choise is not valid."
    ;;
esac
