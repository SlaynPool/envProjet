#!/bin/bash

#########################################
#Le projet consiste a auto installer une appli simplement via le lien git preciser
#########################################




##### On evalue L'existence du dossier .env /!\ La fonction Fais un cd dans notre FHS Fraichement crée ou l'existent 
evalEnv(){
    cd $HOME/.env/
    RETVAL=$?
    if [ "$RETVAL" -ne "0" ]
    then 
        echo "$HOME/.env/ not found. Do you want to create it ? [yes-NO]"
        read $ask
        if echo "$ask" = "yes" 

        then
            mkdir $HOME/.env/
            cd $HOME/.env/
            echo "do you want to create LINUX FHS in .env folder [yes-NO]"
            read $ask2
            if  echo "$ask2" = "yes" 
            then 
                mkdir -p build bin etc lib opt sbin usr usr/bin usr/dict usr/doc usr/doc usr/etc usr/include usr/info usr/lib usr/local usr/man usr/man usr/sbin usr/share usr/spool usr/src var/catman var/lib var/local var/lock var/log var/run var/spool var/tmp
                return 0
            else
                echo "May the force be with you"
                return 0
            fi
        else
            echo "EXIT" 
            exit

        fi
    
    else
        cd $HOME/.env/
        return 0
    fi

}



#On crée le bashrc qui nous sera confortable
bashrcEval(){
    cat $HOME/.bashrc
    RETVAL=$?
    if [ "$RETVAL" -eq "0" ]
    then 
        cp $HOME/.bashrc $HOME/.bashrcOLD
        echo "export PATH='$HOME/.env/bin:$PATH'">$HOME/.bashrc 
        echo "export LDFLAGS='-L$HOME/.env/lib'">>$HOME/.bashrc
        echo "export CPPFLAGS='-I/$HOME/.env/include'">>$HOME/.bashrc
        echo "export C_INCLUDE_PATH='$HOME/.env/include'">>$HOME/.bashrc
        echo "export LD_LIBRARY_PATH='$HOME/.env/lib'">>$HOME/.bashrc
    else 
        echo "export PATH='$HOME/.env/bin:$PATH'">$HOME/.bashrc 
        echo "export LDFLAGS='-L$HOME/.env/lib'">>$HOME/.bashrc
        echo "export CPPFLAGS='-I/$HOME/.env/include'">>$HOME/.bashrc
        echo "export C_INCLUDE_PATH='$HOME/.env/include'">>$HOME/.bashrc
        echo "export LD_LIBRARY_PATH='$HOME/.env/lib'">>$HOME/.bashrc
    fi


}
#On remet le bashrc comme c'etait avant Enfin on rajoute a l'ancien BASHRC le PATH  pour le bin
bashrcReverse(){
    cat $HOME/.bashrcOLD
    RETVAL=$?
    if [ "$RETVAL" -eq "0" ]
    then
        rm $HOME/.bashrc
        mv $HOME/.bashrcOLD $HOME/.bashrc
        echo "export PATH='$HOME/.env/bin:$PATH"
    else
        rm $HOME/.bashrc
    fi
}


gitclone(){
    cd $HOME/.env/build/currentInstall/
    RETVAL=$?
    if [ "$RETVAL" -eq "0" ]
    then
        cd $HOME/.env/build
        mv $HOME/.env/build/currentInstall/ $HOME/.env/build/WaitInstall/
        git clone $1 $HOME/.env/build/currentInstall
    else        
        git clone $1 $HOME/.env/build/currentInstall
    fi
    



}

install(){
    cd $HOME/.env/build/currentInstall
    #Si l'autoGen existe
    cat autogen.sh
    RETVAL=$?
    if [ "$RETVAL" -eq "0" ]
    then
       /bin/bash ./autogen.sh --prefix=$HOME/.env/
       /bin/bash configure --prefix=$HOME/.env/
       make
       make install
    else
       cat configure
       RETVAL=$?
       if [ "$RETVAL" -eq "0" ]
       then  
           ./configure --prefix=$HOME/.env/
           make
           make install
       fi
    fi
    
}

evalEnv
bashrcEval
gitclone "$1"
install
