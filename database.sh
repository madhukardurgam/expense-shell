#!/bin/bash
#installing the sql and git with reduced no of lines
USERID=$(id -u)
#color coding
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
#path to store the logs
LOGS_FOLDER="/var/log/expense-logs"
#name of the file
LOG_FILE="$(echo $0 | cut -d "." -f1)"
#timestamp of execution
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
#full logfile name
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2..... $R failure $N"
        exit 1
    else
        echo -e "$2..... $G success $N"
    fi
}

if [ $USERID -ne 0 ]
then 
    echo "you do not have the root access to run the script"
    exit 1
fi 

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "enabling mysql-server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "starting mysql-server"

mysql -h mysql.durgam.online -u root -pExpenseApp@1 -e 'show databases;' $LOG_FILE_NAME

if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ExpenseApp@1 $LOG_FILE_NAME
    VALIDATE $? "Setting Root Password"
else
    echo -e "setting the root password already setup... $Y SKIPPING $N"
fi