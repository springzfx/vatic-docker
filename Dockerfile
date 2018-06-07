# binode/lamp: https://hub.docker.com/r/linode/lamp/
# defult mysql password: Admin2015
FROM linode/lamp:latest 

# ADD  sources.list  /etc/apt/sources.list


# install python relative dependencies
RUN apt-get update && \
    apt-get install -y \
    python python-pip  python-setuptools python-dev \
    libavcodec-dev libavformat-dev libswscale-dev libjpeg62 libjpeg62-dev libfreetype6 libfreetype6-dev gfortran\
    libmysqlclient-dev  &&\
    apt-get clean &&\
    sudo pip install SQLAlchemy==1.0.0 && \
    sudo pip install wsgilog==0.3 && \
    sudo pip install cython==0.20 && \
    sudo pip install mysql-python==1.2.5 && \
    sudo pip install munkres==1.0.7 && \
    sudo pip install parsedatetime==1.4 && \
    sudo pip install argparse && \
    sudo pip install numpy==1.9.2 && \
    sudo pip install Pillow

# install ffmpeg
RUN apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:mc3man/trusty-media -y && \
    apt-get update && \
    apt-get install -y ffmpeg gstreamer0.10-ffmpeg && \
    add-apt-repository -r ppa:mc3man/trusty-media -y && \
    apt-get remove -y software-properties-common python-software-properties && \
    apt-get autoremove -y && \
    apt-get clean


RUN apt-get update && \
    apt-get install -y links python-scipy && \
    apt-get clean

RUN apt-get update && \
    apt-get install -y php5-cgi libapache2-mod-php5 libapache2-mod-wsgi &&\
    apt-get clean

COPY src /root/

# build up turkic and pyvision
# We need to adjust some of these guys's import statements...
RUN cd /root/turkic && sudo python setup.py install && \
    cd /root/pyvision && sudo python setup.py install && \
    sed  -i'' "s/import Image/from PIL import Image/" \
        /usr/local/lib/python2.7/dist-packages/pyvision-0.3.1-py2.7-linux-x86_64.egg/vision/frameiterators.py \
        /usr/local/lib/python2.7/dist-packages/pyvision-0.3.1-py2.7-linux-x86_64.egg/vision/ffmpeg.py \
        /usr/local/lib/python2.7/dist-packages/pyvision-0.3.1-py2.7-linux-x86_64.egg/vision/visualize.py \
        /usr/local/lib/python2.7/dist-packages/pyvision-0.3.1-py2.7-linux-x86_64.egg/vision/pascal.py

COPY config/000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY config/apache2.conf /etc/apache2/apache2.conf
RUN  sudo cp /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled 
COPY config/config.py /root/vatic/config.py


# service apache2 start
# service mysql start
RUN service mysql start && mysqladmin -u root -pAdmin2015 password ''

RUN service mysql start && \
    cd /root/vatic && \
    mysql -u root --execute="CREATE DATABASE vatic;" && \
    turkic setup --database && \
    turkic setup --public-symlink

RUN sudo chmod -R 755 /root/vatic/public && \
    find /root/ -type d -exec chmod 755 {} \; && \
    sudo chmod -R 755 /var/www

EXPOSE 80 443 3306
# VOLUME ["/var/lib/mysql"]

# RUN apt-get install -y coreutils &&\
#     apt-get clean


# Debug tools
# RUN apt-get install -y nano w3m man

# COPY ascripts /root/vatic/ascripts
# COPY scripts /root/vatic
# moved to the end to make troubleshooting quicker

# Prepare workspace for use

# VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"]
# ENTRYPOINT ["/root/vatic/startup.sh"]
