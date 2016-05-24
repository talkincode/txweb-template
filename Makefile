install:
	(\
	virtualenv venv --relocatable;\
	test -d /data/{txwebproject}/data || mkdir -p /data/{txwebproject}/data;\
	ln -s /data/{txwebproject} /var/{txwebproject};\
	test -f /etc/{txwebproject}.conf || cp etc/{txwebproject}.conf /etc/{txwebproject}.conf;\
	test -f /etc/{txwebproject}.json || cp etc/{txwebproject}.json /etc/{txwebproject}.json;\
	test -f /etc/init.d/{txwebproject} || cp etc/{txwebproject} /etc/init.d/{txwebproject};\
	chmod +x /etc/init.d/{txwebproject} && chkconfig {txwebproject} on;\
	test -f /usr/lib/systemd/system/{txwebproject}.service || cp etc/{txwebproject}.service /usr/lib/systemd/system/{txwebproject}.service;\
	chmod 754 /usr/lib/systemd/system/{txwebproject}.service && systemctl enable {txwebproject};\
	systemctl daemon-reload;\
	)

install-deps:
	(\
	yum install -y epel-release;\
	yum install -y wget zip python-devel libffi-devel openssl openssl-devel gcc git;\
	yum install -y czmq czmq-devel python-virtualenv supervisor;\
	yum install -y mysql-devel MySQL-python redis;\
	test -f /usr/local/bin/supervisord || ln -s `which supervisord` /usr/local/bin/supervisord;\
	)

venv:
	(\
	test -d venv || virtualenv venv;\
	venv/bin/pip install -U pip;\
	venv/bin/pip install -U wheel;\
	venv/bin/pip install -U Click;\
	venv/bin/pip install -U --no-deps https://github.com/talkincode/txweb/archive/master.zip;\
	venv/bin/pip install -U -r requirements.txt;\
	)


upgrade:
	(\
	git pull --rebase --stat origin master;\
	service {txwebproject} restart;\
	)


txweb:
	venv/bin/pip install -U --no-deps https://github.com/talkincode/txweb/archive/master.zip

initdb:
	python servctl initdb -f -c /etc/{txwebproject}.json

inittest:
	python servctl inittest -c /etc/{txwebproject}.json

clean:
	rm -fr venv

reconfig:
	(\
	rm -f /etc/{txwebproject}.conf && cp etc/{txwebproject}.conf /etc/{txwebproject}.conf;\
	rm -f /etc/{txwebproject}.json && cp etc/{txwebproject}.json /etc/{txwebproject}.json;\
	rm -f /etc/init.d/{txwebproject} && cp etc/{txwebproject} /etc/init.d/{txwebproject};\
	chmod +x /etc/init.d/{txwebproject} && chkconfig {txwebproject} on;\
	rm -f /usr/lib/systemd/system/{txwebproject}.service && cp etc/{txwebproject}.service /usr/lib/systemd/system/{txwebproject}.service;\
	chmod 754 /usr/lib/systemd/system/{txwebproject}.service && systemctl enable {txwebproject};\
	systemctl daemon-reload;\
	)

run:
	venv/bin/txwebctl  --conf=etc/{txwebproject}.json --dir={txwebproject} --logging=none

all:install-deps venv install

.PHONY: venv initdb inittest run install-deps venv txweb install



	