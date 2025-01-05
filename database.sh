#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
R="\e[0m"
LOG_PATH="/var/log/expense-logs"
LOG_FILE="(echo $0 | cut -d "." -f1)"
TIMESTAMP="($date +%Y-%m-%d-%H-%M-%S)"
LOG_FILE_NAME="($OG_PATH/$LOG_FILE-$TIMESTAMP.log)"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "you need sudo access to run the script"
        exit 1
    fi  
}
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ..... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ..... $G SUCCESS $N"
}
echo "script started executing at: $TIMESTAMP "
CHECK_ROOT

dnf install mysql-server -y
VALIDATE $? "installing mysql-server"

systemctl enable mysqld
VALIDATE $? "enabling mysql-server"

systemctl start mysqld
VALIDATE $? "starting mysql-server"

mysql -h data.durgam.online -u root -p ExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "setting root password"
else
    echo -e "mysql root password is already setup... $Y SKIPPING $N "
fi

