#arm32v7/debian,arm64v8/debian,amd64/debian
ARG OSLINE=
#bullseye,bookworm
ARG OSVERSION
FROM ${OSLINE}:${OSVERSION}

COPY files .

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y python3-bluez \
python3-pyudev \
python3-serial \
python3-gdal \
python3-netifaces \
python3-pil \
python3-pigpio \
gnupg \
iproute2

RUN apt-key add - < ./oss.boating.gpg.key
RUN mv oss.boating.gpg /usr/share/keyrings/

RUN printf "deb [signed-by=/usr/share/keyrings/oss.boating.gpg] https://www.free-x.de/debpreview RELEASE main\n" > /etc/apt/sources.list.d/avnav.list 
RUN printf "deb [signed-by=/usr/share/keyrings/oss.boating.gpg] https://www.free-x.de/debian RELEASE main\n" >> /etc/apt/sources.list.d/avnav.list
RUN . /etc/os-release && sed -i s/RELEASE/$VERSION_CODENAME/g /etc/apt/sources.list.d/avnav.list
RUN apt-get update 
RUN apt-get install -y avnav avnav-mapproxy-plugin avnav-history-plugin avnav-ochartsng
