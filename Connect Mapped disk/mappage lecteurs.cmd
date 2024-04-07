@echo off
net use b: \\srv-nas-info\users\mjacotet /persistent:yes
net use j: \\filer\adm$ /persistent:yes
net use i: \\filer\apps$ /persistent:yes
net use k: \\filer\medical$ /persistent:yes
net use f: \\filer\forum$ /persistent:yes
net use U: \\filer\users$ /persistent:yes