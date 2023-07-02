# Valheim Server with S3 Backup

Run your own valheim server with s3 backups, based on https://github.com/lloesche/valheim-server-docker

## Configuration

### Imports

If you have existing worlds, copy the ```WORLD_NAME.db``` and ```WORLD_NAME.fwl``` files to ```./worlds_local```

### docker-compose

Copy the ```example.env``` file to ```.env``` and configure as per the instructions in the file.

You must make sure that your firewalls and NAT config allow for internet access to the running machine on ports:

- 2456-2458/udp
- 9001/tcp

### AWS

You will need an s3 bucket to store your backups, these are cheap and easy to create.

You will also need to create an IAM user for the uploader with its own access keys, add these to the env file as per the instructions there.

The IAM user should have the following attached policy (inline or a dedicated policy, up to you):
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Resource": [
                "arn:aws:s3:::YOUR_BUCKET_NAME",
                "arn:aws:s3:::YOUR_BUCKET_NAME/*"
            ],
            "Sid": "S3SyncPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject"
            ]
        }
    ]
}
```

## Running

### Manually

```bash
docker-compose up
```

### Systemd

**You will need to run the following as root**

Checkout this repo to ```/etc/docker/compose/valheim-server```:
```bash
mkdir -p /etc/docker/compose
git clone https://github.com/jamesstow/valheim-server.git /etc/docker/compose/valheim-server
```

If you dont have a docker-compose systemd unit, create one as so:

```bash
cat <<EOF > /etc/systemd/system/docker-compose@.service
[Unit]
Description=%i service with docker compose
PartOf=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=true
WorkingDirectory=/etc/docker/compose/%i
ExecStart=/usr/bin/docker-compose up -d --remove-orphans
ExecStop=/usr/bin/docker-compose down

[Install]
WantedBy=multi-user.target
EOF
```

Then start your docker server with
```bash
systemctl enable --now docker-compose@valheim-server.service
```