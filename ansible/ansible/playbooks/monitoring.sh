#!/bin/bash
# setup-monitoring.sh

echo "=== Setting up Docker and Prometheus Monitoring ==="

# 1. Install community.docker collection
echo "1. Installing community.docker collection..."
ansible-galaxy collection install community.docker

# 2. Create requirements file
echo "2. Creating requirements.yml..."
cat > requirements.yml << 'EOF'
---
collections:
  - name: community.docker
    version: 3.0.0
EOF

# 3. Create inventory file (update with your IP)
echo "3. Creating inventory file..."
read -p "Enter your managed node IP: " NODE_IP
read -p "Enter SSH username: " SSH_USER

cat > hosts.ini << EOF
[all]
monitoring_host ansible_host=${NODE_IP} ansible_user=${SSH_USER}

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

# 4. Run the playbook
echo "4. Running the playbook..."
ansible-playbook -i hosts full-setup.yml --become-user managetest

echo "=== Setup Complete! ==="
echo "Access Prometheus at: http://${NODE_IP}:9090"
echo "Node metrics at: http://${NODE_IP}:9100/metrics"
