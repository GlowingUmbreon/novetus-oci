FROM archlinux:latest
LABEL Name=novetus Version=0.0.2

# Use local pacman cache
#RUN echo "Server = http://127.0.0.1:9129/repo/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
RUN pacman -Syu -q --noconfirm wine wine-mono sway wayvnc strace
# Remove nice capabilities from sway binary to ensure compatibility with containers
RUN setcap -r /usr/bin/sway

COPY entry.sh /opt/entry.sh

RUN useradd -m -u 1000 novetus
RUN mkdir -p -m 0700 /run/user/1000 && chown novetus:novetus /run/user/1000

USER novetus
RUN WINEDEBUG=-all wineboot --init 
RUN winecfg /v winxp 
RUN wine reg add "HKCU\\Software\\Wine\\Drivers" /v Audio /d "null" 
RUN wineserver -w
COPY --chown=novetus:novetus .config /home/novetus/.config
COPY --chown=novetus:novetus novetus/data /home/novetus/novetus

ENV NOVETUS_CLIENT="2012M" \
    NOVETUS_PLAYERS=9 \
    NOVETUS_NAME="NAME - YEAR" \
    NOVETUS_PORT=10000 \
    NOVETUS_MASTERSERVER=""

VOLUME /opt/place.rbxl
EXPOSE 5900
ENTRYPOINT ["/opt/entry.sh"]
