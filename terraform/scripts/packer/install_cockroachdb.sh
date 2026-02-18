#!/bin/bash

set -eux

# ============================================================
# Install CockroachDB
# ============================================================

cd /tmp

curl -L https://binaries.cockroachdb.com/cockroach-v23.1.11.linux-amd64.tgz | tar -xz

sudo cp cockroach-v23.1.11.linux-amd64/cockroach /usr/local/bin/

sudo chmod +x /usr/local/bin/cockroach


# ============================================================
# Create cockroach user
# ============================================================

sudo useradd --system --home /var/lib/cockroach --shell /bin/false cockroach || true

sudo mkdir -p /var/lib/cockroach

sudo chown cockroach:cockroach /var/lib/cockroach


# ============================================================
# Create data directory
# ============================================================

sudo mkdir -p /data

sudo chown cockroach:cockroach /data


# ============================================================
# Create mount script
# ============================================================

sudo tee /usr/local/bin/mount-data.sh > /dev/null << 'EOF'
#!/bin/bash

DEVICE="/dev/xvdb"
MOUNT_POINT="/data"

while [ ! -b $DEVICE ]; do
  sleep 1
done

if ! blkid $DEVICE; then
  mkfs.ext4 $DEVICE
fi

if ! mount | grep $MOUNT_POINT; then
  mount $DEVICE $MOUNT_POINT
fi

chown cockroach:cockroach $MOUNT_POINT
EOF


sudo chmod +x /usr/local/bin/mount-data.sh


# ============================================================
# Create mount service
# ============================================================

sudo tee /etc/systemd/system/mount-data.service > /dev/null << 'EOF'
[Unit]
Description=Mount CockroachDB Data Volume
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/mount-data.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF


# ============================================================
# Create CockroachDB service
# ============================================================

sudo tee /etc/systemd/system/cockroach.service > /dev/null << 'EOF'
[Unit]
Description=CockroachDB
After=network.target mount-data.service
Requires=mount-data.service

[Service]

User=cockroach

ExecStart=/usr/local/bin/cockroach start-single-node \
--store=/data \
--listen-addr=0.0.0.0 \
--http-addr=0.0.0.0:8080 \
--insecure

Restart=always

LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF


# ============================================================
# Enable services
# ============================================================

sudo systemctl daemon-reexec

sudo systemctl enable mount-data

sudo systemctl enable cockroach


# ============================================================
# Clean
# ============================================================

rm -rf /tmp/cockroach*
