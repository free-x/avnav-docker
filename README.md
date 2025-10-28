# AvNav Docker (Free-X)

Unofficial Docker image for [AvNav](https://www.wellenvogel.net/software/avnav/docs/), an open-source marine navigation software for Raspberry Pi. This image includes additional plugins and is built from the official oss.boating Debian repository.

**Docker Hub**: [xfreex/avnav-daily](https://hub.docker.com/r/xfreex/avnav-daily)
**Upstream Repository**: [free-x/avnav-docker](https://github.com/free-x/avnav-docker)

## Overview

This Docker image packages AvNav with extended functionality, making it ideal for marine navigation on Raspberry Pi and other platforms. It's designed to work seamlessly with other marine software like Signal K.

## Features

- **Multi-architecture support**: ARM64 (Raspberry Pi), AMD64 (development)
- **Based on Debian Bookworm**: Stable base with official oss.boating repository
- **Additional Plugins Included**:
  - `avnav-mapproxy-plugin`: Chart server for serving maps to other applications
  - `avnav-ochartsng`: Support for commercial o-charts chart format
- **Host networking**: Better device discovery and multicast support
- **Persistent storage**: Standard `/var/lib/avnav` location
- **Hardware access ready**: Privileged mode for serial devices and hardware

## Quick Start

### Using Docker Run

```bash
docker run -d \
  --name avnav \
  --network host \
  --privileged \
  --user 1000:1000 \
  -v avnav-data:/var/lib/avnav \
  -v /dev:/dev \
  -e UID=1000 \
  -e GID=1000 \
  xfreex/avnav-daily:latest
```

Access AvNav at `http://localhost:8080`

### Using Docker Compose

```yaml
services:
  avnav:
    image: xfreex/avnav-daily:latest
    container_name: avnav
    restart: unless-stopped
    privileged: true
    user: 1000:1000
    network_mode: host
    volumes:
      - /dev:/dev
      - ./avnav:/var/lib/avnav
    ports:
      - 8080:8080
      - 8082:8082
    environment:
      - UID=1000
      - GID=1000
```

## Volumes

- `/var/lib/avnav` - AvNav data directory (charts, tracks, waypoints, logs, config)
- `/dev` - Device access for serial ports (NMEA devices)

## Ports

- `8080` - Web interface (HTTP)
- `8082` - Additional AvNav port

## Environment Variables

- `UID` - User ID for AvNav process (default: 1000)
- `GID` - Group ID for AvNav process (default: 1000)

## Network Mode

This image uses **host networking** (`network_mode: host`) for several reasons:
- Better device discovery (mDNS/Bonjour)
- Multicast support for marine protocols
- Simplified Signal K integration
- Direct access to network interfaces

With host networking, AvNav listens directly on port 8080 of the host.

## Signal K Integration

AvNav can automatically discover and connect to Signal K servers on the local network. To manually configure Signal K connection:

1. Access AvNav web interface at `http://your-device-ip:8080`
2. Go to Settings → Connections
3. Add Signal K connection (typically `localhost:3000` if on same host)

## Hardware Access

### Serial Ports (NMEA 0183/2000)

The image requires privileged mode and `/dev` volume mount for serial device access:

```bash
docker run -d \
  --name avnav \
  --network host \
  --privileged \
  -v /dev:/dev \
  -v avnav-data:/var/lib/avnav \
  xfreex/avnav-daily:latest
```

Configure serial ports through the AvNav web interface.

## Chart Management

### Supported Chart Formats

- **MBTiles**: Popular raster chart format
- **gemf**: Efficient chart storage format
- **O-Charts**: Commercial chart format (requires license)
- **XML**: Chart conversion format
- **Online sources**: Via MapProxy plugin

### Adding Charts

1. Access AvNav web interface
2. Navigate to Files section
3. Upload chart files to the appropriate directory
4. Charts will be automatically detected and displayed

## Plugins

### MapProxy Plugin

Included by default. Allows AvNav to:
- Serve charts to other applications
- Act as a chart server for the network
- Convert and cache online chart sources

### O-Charts Plugin

Included by default. Enables:
- Commercial o-charts support
- License management through AvNav interface
- Access to official chart providers

## Building from Source

```bash
# Clone repository
git clone https://github.com/free-x/avnav-docker.git
cd avnav-docker

# Build single architecture
docker build -t avnav:local .

# Build multi-architecture
docker buildx build --platform linux/amd64,linux/arm64 -t avnav:local .
```

## Differences from Other AvNav Images

Compared to basic AvNav Docker images, this image includes:
- ✅ Official oss.boating APT repository
- ✅ MapProxy plugin pre-installed
- ✅ O-Charts support pre-installed
- ✅ Host networking configuration
- ✅ Proper UID/GID handling
- ✅ Stable Debian Bookworm base

## Troubleshooting

### Cannot access web interface

- Check that port 8080 is not blocked by firewall
- Verify container is running: `docker ps`
- Check logs: `docker logs avnav`

### Serial devices not detected

- Ensure `--privileged` flag is set
- Verify `/dev` volume is mounted
- Check device permissions on host
- Add user to `dialout` group if needed

### Signal K not connecting

- Verify Signal K is running and accessible
- Check network connectivity between containers
- Use host networking for both containers
- Verify Signal K is listening on expected port (usually 3000)

## Version Information

- **Base Image**: debian:bookworm-slim
- **AvNav Source**: Official oss.boating APT repository
- **Update Frequency**: Daily builds available
- **Recommended Tag**: Use dated tags (e.g., `20250901`) for production

## Documentation

- [AvNav Official Documentation](https://www.wellenvogel.net/software/avnav/docs/)
- [AvNav GitHub Repository](https://github.com/wellenvogel/avnav)
- [oss.boating Website](https://www.free-x.de/)
- [Docker Hub Page](https://hub.docker.com/r/xfreex/avnav-daily)

## License

This Dockerfile and associated scripts are licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

AvNav itself is licensed under the MIT License by Andreas Vogel.

## Credits

- **AvNav**: Created and maintained by Andreas Vogel
- **Docker Image**: Created by free-x
- **Repository**: https://github.com/free-x/avnav-docker

## Support

For issues with this Docker image, please open an issue on the [GitHub repository](https://github.com/free-x/avnav-docker/issues).

For AvNav-specific questions, refer to:
- [AvNav Documentation](https://www.wellenvogel.net/software/avnav/docs/)
- [AvNav GitHub Issues](https://github.com/wellenvogel/avnav/issues)
