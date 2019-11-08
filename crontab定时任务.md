云犁数据库通过`shell脚本 + crontab`的方式进行自动备份。

# 关于cron

```bash
# 使用crontab -h查看帮助
iZ25nijqt60Z:~# crontab -h
crontab: invalid option -- 'h'
crontab: usage error: unrecognized option
usage:	crontab [-u user] file
	crontab [ -u user ] [ -i ] { -e | -l | -r }
		(default operation is replace, per 1003.2)
	-e	(edit user's crontab)
	-l	(list user's crontab)
	-r	(delete user's crontab)
	-i	(prompt before deleting user's crontab)
```

# 添加定时任务

通过`crontab -e`进行定时任务的编辑操作

```bash
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
0 6 * * * /usr/sbin/backmysql.sh
0 0 * * * /usr/sbin/backmysql-yunli.sh

                                                                                                                              [ Read 25 lines ]
^G Get Help                                  ^O WriteOut                                  ^R Read File                                 ^Y Prev Page                                 ^K Cut Text                                  ^C Cur Pos
^X Exit                                      ^J Justify                                   ^W Where Is                                  ^V Next Page                                 ^U UnCut Text                                ^T To Spell
```
如上所示，新增加定时任务的时候，可以直接在`0 0 * * * /usr/sbin/backmysql-yunli.sh`这句配置下追加。

编辑完成后使用`ctrl + x`退出编辑