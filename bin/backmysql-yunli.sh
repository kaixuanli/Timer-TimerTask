######################## BASIC ######################
DATE=`date +%Y%m%d%H%M`
# database name
DATABASE=yunli
# database username
DB_USER=root
# database password
DB_PASS=quid0s
# backup path
BACKUP=/bak/mysqldata/yunli
# backup file path
BACK_FILE_PATH=${BACKUP}\/${DATABASE}_${DATE}.sql.gz
######################## BASIC ######################

######################## FTP ########################
FTP_HOST=61.149.7.121
FTP_PORT=23
FTP_BACKUP_FILE_PATH=/backups/mysql/yunli/${DATABASE}_${DATE}.sql.gz
######################## FTP ########################

######################## AliYun OSS ########################
OSS_BACKUP_FILE_PATH=oss://inbackup/mysql/yunli/${DATABASE}_${DATE}.sql.gz
######################## AliYun OSS ########################

#backup command
echo ">> Start backing up the database [$DATABASE]"
/usr/bin/mysqldump -u$DB_USER -p$DB_PASS -h 127.0.0.1 -R --opt $DATABASE |gzip > ${BACK_FILE_PATH}
echo ">> Your database backup successfully completed."

#just backup the latest 5 days
find ${BACKUP} -name "${DATABASE}_*.sql.gz" -type f -mtime +5 -exec rm {} \; > /dev/null 2>&1

echo ">> Send the backup files to the FTP server."
scp -P $FTP_PORT $BACK_FILE_PATH $FTP_HOST:$FTP_BACKUP_FILE_PATH
echo ">> Transmission completed!"

echo ">> Send the backup files to the OSS server."
ossutil64 cp $BACK_FILE_PATH $OSS_BACKUP_FILE_PATH
echo ">> Transmission completed!"