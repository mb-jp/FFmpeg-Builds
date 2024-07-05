#!/bin/bash
set -xe

function setup()
{    
    function filter_scripts()
    {
        function filter()
        {
            for p in $(cat $2 );
            do
                if [[ $1 == *$p ]]
                then    
                    return
                fi
            done
            
            rm -rf $1
            echo remove $1     
        }

        echo filtering scripts.d using $1

        for script in scripts.d/**; do
            filter $script $1
        done

        for script in scripts.d/**/; do
            filter $script $1
        done

        # this is a fix for script to work

        mkdir scripts.d/dummy
        
        cat >scripts.d/dummy/dummy.sh <<EOL
#!/bin/bash

SCRIPT_SKIP="1"s

ffbuild_enabled() {
    return -1;
}

ffbuild_dockerfinal() {
    return 0
}

ffbuild_dockerdl() {
    true
}

ffbuild_dockerlayer() {
    return 0
}

ffbuild_dockerstage() {
    return 0
}

ffbuild_dockerbuild() {
    return 0
}

ffbuild_ldexeflags() {
    return 0
}
EOL
    }

    [[ -d .cache ]] && rm -rf .cache
    git restore -s@ -SW -- scripts.d
    filter_scripts filter-$1-lgpl.txt
}

if ! command -v docker &> /dev/null
then
    sudo apt-get update -y
    sudo apt-get install -y bash git ca-certificates curl

    # Install Docker Engine on Ubuntu
    # https://docs.docker.com/engine/install/ubuntu/

    echo install docker
    #sudo apt-get update
    #sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo set upp grupes 

    # sudo groupadd docker
    sudo usermod -aG docker ${USER}
    #su -s ${USER}
fi
