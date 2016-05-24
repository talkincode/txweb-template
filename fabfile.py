#!/usr/bin/env python
import sys,os
sys.path.insert(0,os.path.dirname(__file__))
from fabric.api import *
from {txwebproject} import __version__

env.user = 'root'
env.hosts = ['0.0.0.0']

def push():
    message = raw_input(u"input git commit message:")
    local("git add .")
    try:
        local("git commit -m \'%s: %s\'"%(__version__,message))
        local("git push origin master")
    except:
        print u'no commit'
    
def deploy():
    gitrepo = "git@git.coding.net:toughstruct/{txwebproject}.git"
    rundir = "/opt/{txwebproject}"
    run("test -d {rundir} || git clone -b master {gitrepo} {rundir}".format(rundir=rundir,gitrepo=gitrepo))
    with cd(rundir):
        run("git pull --rebase --stat origin master")
        run("make all")
        run("make initdb")
        run("service {txwebproject} restart")
        run("service {txwebproject} status")

def upgrade():
    with cd("/opt/{txwebproject}"):
        run("git pull --rebase --stat origin master")
        run("service {txwebproject} restart")
        run("service {txwebproject} status")

def tail():
    run("tail -f /var/{txwebproject}/{txwebproject}.log")

def tail100():
    run("tail -n 100 /var/{txwebproject}/{txwebproject}.log")

def status():
    run("service {txwebproject} status")

def uplib():
    with cd("/opt/{txwebproject}"):
        run("make txweb")

def cmd():
    message = raw_input(u"input bash command:")
    run(message)
