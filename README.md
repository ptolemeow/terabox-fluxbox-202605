# terabox-fluxbox-202605
Built image ~1.56GB, consisting of:
- TeraBoxBox 1.44.3
- Double Commander 1.1.11
- Fluxbox (a lightweight window manager)
- Ubuntu 24.04 LTS minimal
- noVNC
- x11vnc
- XTerm
- busybox


# CLONE REPO
```sh
git clone https://github.com/ptolemeow/terabox-fluxbox-202605
```


# DOWNLOAD TERABOX .DEB
```sh
cd terabox-fluxbox-202605
wget 'https://data.nephobox.com/issue/terabox/Linux/1.44.3/TeraBox_1.44.3_amd64.deb'
```


# BUILD IT
```sh
docker build -t ptolemeow/tbox1443:2605 .
```


## VNC Password
*0000*

To change it, find & modify this line in the Dockerfile:
```sh
x11vnc -storepasswd '0000' /root/.vnc/passwd
```


## DEFAULT LOCALE
*Asia/Taipei*

To change it, find & modify these lines in the Dockerfile:
```sh
TZ=Asia/Taipei
```
```sh
ln -f -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime
```


# START IT
```sh
docker run -d --rm \
	-v /usr/share/fonts/opentype:/usr/share/fonts/opentype-0:ro \
	-v /usr/share/fonts/truetype:/usr/share/fonts/truetype-0:ro \
	-v ~/.my-docker-persist/terabox/.config:/root/.config:rw \
	-v ~/Downloads:/dl:rw \
	-v ~/Documents:/ul:ro \
	-p 6080:6080 \
	-p 5901:5901 \
	ptolemeow/tbox1443:2605
```

- VNC port: **5901**
- noVNC port: **6080**

#### HINT 1: Fonts on the host can be shared with the container via [volume mounts](https://docs.docker.com/engine/storage/volumes/#options-for---volume).

#### HINT 2: To preserve TeraBox and Double Commander settings, mount a local path as `/root/.config/` in Docker, e.g.

```sh
-v ~/.my-docker-persist/terabox/.config:/root/.config
```
#### HINT 3: Mount other paths according to your needs, e.g.
```sh
-v ~/Downloads:/dl:rw \
-v ~/Documents:/ul:ro
```

# ENJOY IT
- Connect to port **5901** using any VNC viewer clients
- Alternatively, use any browser to connct to: http://0.0.0.0:6080
- Right-click anywhere on the X desktop to access the Fluxbox menu, where you can launch the applications TeraBox, DoubleCmd, or XTerm
