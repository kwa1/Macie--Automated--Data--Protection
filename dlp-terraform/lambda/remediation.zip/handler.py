import boto3
import logging

s3 = boto3.client('s3')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Automatically removes public ACLs and tags sensitive objects detected by Macie.
    Event example: AWS Macie finding
    """
    logger.info(f"Event received: {event}")

    for record in event.get('detail', {}).get('resourcesAffected', []):
        bucket_name = record.get('s3Bucket', {}).get('name')
        object_key  = record.get('s3Object', {}).get('key')

        if not bucket_name or not object_key:
            continue

        try:
            # Remove public ACLs
            s3.put_object_acl(
                Bucket=bucket_name,
                Key=object_key,
                ACL='private'
            )
            # Tag object as sensitive
            s3.put_object_tagging(
                Bucket=bucket_name,
                Key=object_key,
                Tagging={
                    'TagSet': [
                        {'Key': 'Sensitive', 'Value': 'true'}
                    ]
                }
            )
            logger.info(f"Remediated {bucket_name}/{object_key}")

        except Exception as e:
            logger.error(f"Error remediating {bucket_name}/{object_key}: {e}")
