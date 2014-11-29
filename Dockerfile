FROM tdmedia/supervisor
MAINTAINER Rob Taylor <rt@tdmedia.com>

## CONFIGURATION

# enable networking - only needed for some started by init.d
# currently using supervisord instead so not needed
#RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# add our start up scripts
ADD ./run/start.sh /start.sh
RUN chmod 755 /start.sh

# and configuration files
ADD ./conf/supervisord.conf /etc/supervisord.conf
ADD ./conf/httpd.conf /etc/httpd/conf/httpd.conf
ADD ./conf/php.conf /etc/httpd/conf/php.conf
ADD ./conf/my.cnf /etc/my.cnf
ADD ./conf/php.ini /etc/php.ini
ADD ./conf/smb.conf /etc/samba/smb.conf
ADD ./conf/bash_profile /user/.bash_profile
ADD ./conf/zshrc /root/.zshrc
ADD ./conf/zshrc /user/.zshrc

ADD ./conf/milomedia.zsh-theme /root/.oh-my-zsh/themes/milomedia.zsh-theme
ADD ./conf/milomedia.zsh-theme /home/user/.oh-my-zsh/themes/milomedia.zsh-theme

RUN chmod 744 /etc/httpd/conf/httpd.conf && chmod 744 /etc/my.cnf

# add our default user
RUN useradd -G wheel user
# and key directories
RUN mkdir /home/user/.ssh && mkdir /root/.ssh && mkdir /var/run/sshd

# make sure you copy your private key to the conf folder first
ADD ./keys/id_dsa /home/user/.ssh/id_dsa
ADD ./keys/id_dsa /root/.ssh/id_dsa
RUN chmod 600 /home/user/.ssh/id_dsa && chmod 600 /root/.ssh/id_dsa

# If you have rsa, comment out the block above and uncomment the block below
# ADD ./keys/id_rsa /home/user/.ssh/id_rsa
# ADD ./keys/id_rsa /home/user/.ssh/id_rsa
# RUN chmod 600 /home/user/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa

RUN echo user:user | chpasswd && echo 'root:root' | chpasswd

# passwordless sudo for all wheel users! - OK for dev
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# fix sshd so it will run
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# set PST timezone
RUN ln -f /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# Open ports
EXPOSE 22 80 445

# get that party started
# CMD ["/bin/zsh", "/start.sh < /dev/null & > /dev/null &"]
CMD ["/bin/zsh", "/start.sh"]
