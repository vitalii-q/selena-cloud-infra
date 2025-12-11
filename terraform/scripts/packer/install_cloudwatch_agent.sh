#!/bin/bash
set -e

sudo yum install -y amazon-cloudwatch-agent

sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/

# Create default config
cat <<EOF | sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "selena-system",
            "log_stream_name": "{instance_id}/messages"
          }
        ]
      }
    }
  }
}
EOF

sudo systemctl enable amazon-cloudwatch-agent
