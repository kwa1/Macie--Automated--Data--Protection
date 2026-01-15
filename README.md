# Macie--Automated--Data--Protection

Overview

This repository implements an enterprise-grade, automated sensitive data protection pipeline using AWS Macie, EventBridge, Lambda, and Terraform.

The solution automatically:

Detects sensitive data (PII, credentials, financial data)

Blocks public access or risky sharing

Prevents data exfiltration via public S3 or email-style distribution

Produces audit-ready evidence for security, compliance, and leadership

This design follows CISO-aligned security-by-design principles and does not disrupt developer workflows.

Architecture

Flow:

Data is uploaded to S3

AWS Macie classifies objects and detects sensitive data

EventBridge captures Macie findings

Lambda remediates exposure automatically

CloudWatch logs, metrics, and alarms provide visibility

S3 → Macie → EventBridge → Lambda → S3 Remediation
                          ↓
                     CloudWatch / Alerts

                     Repository Structure

macie-automated-data-protection/
├── terraform/
│   ├── main.tf
│   ├── macie.tf
│   ├── eventbridge.tf
│   ├── lambda.tf
│   ├── iam.tf
│   ├── s3.tf
│   ├── cloudwatch.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── lambda/
│   ├── handler.py
│   └── requirements.txt
│
├── diagrams/
│   └── architecture.png
│
├── policies/
│   └── data-classification.md
│
└── README.md

Terraform Components

Key Resources

aws_macie2_account

aws_macie2_classification_job

aws_cloudwatch_event_rule

aws_lambda_function

aws_iam_role + least-privilege policies

aws_cloudwatch_log_group

aws_cloudwatch_metric_alarm

All infrastructure is fully declarative and reproducible.

Lambda Remediation Logic

The Lambda function:

Identifies affected S3 object

Removes public ACLs

Applies restrictive bucket/object policies

Tags objects as Sensitive=true

Logs remediation actions

This ensures data exposure is short-lived or prevented entirely.

Security Gates (Operational)

Control

Purpose

Macie Classification

Detect sensitive data

EventBridge Rule

Real-time response

Lambda Remediation

Automatic enforcement

CloudWatch Alarms

Incident awareness

IAM Least Privilege

Blast-radius control

Compliance Alignment

This implementation supports:

#ISO 27001 – Data protection & access control

#NIST 800-53 – SI, IA, AC controls

#AWS Well-Architected – Security Pillar

#GDPR Article 32 – Security of processing

How This Is Used in the Real World

Prevents accidental public exposure of PII

Stops sensitive files from being distributed externally

Eliminates manual triage and ticket-driven security

Produces defensible audit evidence

This is how mature security organizations operate at scale.

Interview-Ready Explanation

"We use Macie to detect sensitive data, EventBridge to react in near real time, and Lambda to automatically 
remediate exposure by blocking access and tagging data. This ensures protection without slowing down engineering teams."

Prerequisites

AWS Account with Macie enabled

Terraform >= 1.5

Python 3.11

Deployment

cd terraform
terraform init
terraform apply

License

MIT
