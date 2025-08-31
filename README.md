# INSTRUCTIONS

## Project Structure

```
project/
├── main.tf                 # Terraform infrastructure code to create two EC2 instances and security groups
├── app.py                   # Flask application to measure network latency
├── script.sh                # User-data script to install and configure software for Server1
└── README.md                # Documentation
```

## Prerequisites

- Install Terraform CLI
- Install AWS CLI and configure with your credentials

## Steps to Run

1. terraform init // Initialize the Terraform configuration
2. terraform plan // Create an execution plan
3. terraform apply -auto-approve // Apply the changes without confirmation
4. Wait for the instances to be created and configured
5. Access Server1 via its public IP address in a web browser
6. Verify that Server1 can communicate with Server2 with curl http://$PUBLIC_IP_SERVER1/metrics or open in browser: http://$PUBLIC_IP_SERVER1/metrics

## Limitations

- Latency is measured via ICMP, which may be blocked in some environments.
- No authentication/encryption on the metrics endpoint.
- Single measurement every 10 seconds; no historical data.
