# TeraBox-1.44.3 + noVNC + fluxbox + Ubuntu 24.04 LTS minimal

# Step 1：staging image
FROM ubuntu:24.04 AS terabox-staging
ENV DEBIAN_FRONTEND=noninteractive
COPY TeraBox_1.44.3_amd64.deb /tmp/
RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates git /tmp/TeraBox_1.44.3_amd64.deb \
	&& git clone https://github.com/novnc/noVNC.git /opt/novnc \
	&& git clone https://github.com/novnc/websockify.git /opt/novnc/utils/websockify \
	&& rm -rf /var/lib/apt/lists/* /tmp/*

# Step 2：final image
FROM ubuntu:24.04
LABEL author="Ptolemeow"
ENV DEBIAN_FRONTEND=noninteractive

# set environment variables
ENV LANG=C.UTF-8 \
	TZ=Asia/Taipei \
	DISPLAY=:1 \
	RESOLUTION=1776x999x24

RUN apt-get update && apt-get install -y --no-install-recommends \
	xvfb \
	x11vnc \
	fluxbox \
	supervisor \
	python3 \
	python3-pip \
	busybox \
	doublecmd-qt \
	xterm \
	x11-xserver-utils \
	autocutsel \
	bash-completion \
	ca-certificates \
	libnss3 \
	libasound2t64 \
	libatk-bridge2.0-0t64 \
	libatspi2.0-0t64 \
	libgtk-3-0t64 \
&& apt-get autoclean && apt-get autoremove && apt-get autopurge \
&& rm -rf /var/lib/apt/lists/*

COPY --from=terabox-staging /opt/TeraBox /opt/TeraBox
COPY --from=terabox-staging /opt/novnc /opt/novnc
COPY --from=terabox-staging /opt/novnc/utils/websockify /opt/novnc/utils/websockify

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start_vnc.sh /bin/start_vnc.sh
COPY bashrc /etc/bash.bashrc
COPY Xresources /root/.Xresources
COPY fluxbox-menu /etc/X11/fluxbox/

# configure VNC, busybox, time zone and fluxbox
RUN mkdir -p /root/.vnc \
	&& x11vnc -storepasswd '0000' /root/.vnc/passwd \
	&& chmod 755 /bin/start_vnc.sh \
	&& busybox --install -s \
	&& echo '\nsession.screen0.iconbar.alignment:\tLeft' >> /etc/X11/fluxbox/init \
	&& ln -f -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
	&& ln -s /opt/novnc/vnc.html /opt/novnc/index.html

EXPOSE 5901 6080

CMD ["/usr/bin/supervisord"]
