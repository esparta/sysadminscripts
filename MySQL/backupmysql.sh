#!/bin/bash
## backupmysql.sh
## Developer: Espartaco Palma (esparta@gmail.com)
## Date: 2013-01-14
## LastMod: 2013-01-14
## License: GPL
## Description: Procedure to backup MySQL servers
##     Parameters:
##         Host
##         Database
##         Backupfile
## Usage: backupmysql localhost wordpressblog wpb20130114
## Tested on: Ubuntu 11.04 and Ubuntu 12.04

die(){
  echo >&2 "$@"
  echo "Usage: backupmysql.sh <Host> <Database> <BackupName>"
  echo "Sample: backupmysql.sh localhost wordpressblog wpb20130114"
  exit 1
}

[ "$#" -eq 3 ] || die "3 arguments required, $# provided"
mysqldump -u root -h $1 -p $2 | gzip -9 > $3.sql.gz
