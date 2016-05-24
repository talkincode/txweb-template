FROM index.alauda.cn/toughstruct/txweb
MAINTAINER jamiesun <jamiesun.net@gmail.com>

VOLUME [ "/var/{txwebproject}" ]

#rsa
# RUN mkdir -p /root/.ssh
# ADD etc/id_rsa  /root/.ssh/id_rsa
# RUN chmod 700 /root/.ssh
# RUN chmod 600 /root/.ssh/id_rsa
# RUN mkdir -p /etc/ssh
# RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
# RUN echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config

RUN git clone -b master git@git.coding.net:toughstruct/{txwebproject}.git /opt/{txwebproject} && \
    ln -s /opt/{txwebproject}/etc/{txwebproject}.json /etc/{txwebproject}.json

RUN pip install -U --no-deps https://github.com/talkincode/txweb/archive/master.zip
RUN pip install click psutil

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9079

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["txwebctl  --conf=/etc/{txwebproject}.json --dir=/opt/{txwebproject}/{txwebproject} --logging=none"]
