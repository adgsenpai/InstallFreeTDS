# must be ran as sudo
if ! [ $(id -u) = 0 ]; then
    echo "I am not root!"
    exit 1
fi

writeToFile (){
    echo "[FreeTDS]
Description = FreeTDS Driver
Driver = $soPath
    " > /etc/odbcinst.ini
    echo "FreeTDS installed successfully"
}

echo "Installing FreeTDS"

sudo apt-get install unixodbc unixodbc-dev freetds-dev freetds-bin tdsodbc -y

# find libtdsodbc.so in /usr/lib/ and store it in a variable
soPath=$(find /usr/lib/ -name "libtdsodbc.so")

# if soPath is empty, then the file was not found
if [ -z "$soPath" ]
then
    echo "libtdsodbc.so not found"
    exit
fi

# check if /etc/odbcinst.ini contains [FreeTDS] section
if grep -q "\[FreeTDS\]" "/etc/odbcinst.ini"; then
    echo "FreeTDS already installed"
    # do you want to overwrite the file?
    read -p "Do you want to overwrite the file? [y/n] " choice
    case "$choice" in
        y|Y ) writeToFile;;
        n|N ) echo "Not overwriting file";;
        * ) echo "invalid";;
    esac
    
    case "$choice" in
        n|N ) echo "FreeTDS not installed";;
    esac
    exit
fi

echo "Warning: This will overwrite /etc/odbcinst.ini"
read -p "Do you want to continue? [y/n] " choice
case "$choice" in
    y|Y ) echo "Installing FreeTDS"
    writeToFile;;
    n|N ) echo "Not installing FreeTDS";;
    * ) echo "invalid";;
esac
exit 0