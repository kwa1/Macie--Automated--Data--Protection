import boto3
import logging

s3 = boto3.client("s3")
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f"Macie event received: {event}")

    detail = event.get("detail", {})
    resources = detail.get("resourcesAffected", {})

    bucket = resources.get("s3Bucket", {}).get("name")
    obj = resources.get("s3Object", {}).get("key")

    if not bucket or not obj:
        logger.warning("Missing bucket or object in Macie event")
        return

    try:
        # 1️⃣ Read existing tags (do not overwrite)
        existing = s3.get_object_tagging(
            Bucket=bucket,
            Key=obj
        ).get("TagSet", [])

        tag_map = {t["Key"]: t["Value"] for t in existing}

        # 2️⃣ Apply DLP classification tags
        tag_map.update({
            "Sensitive": "true",
            "DataClassification": "PII",
            "Compliance": "GDPR",
            "DetectedBy": "Macie"
        })

        s3.put_object_tagging(
            Bucket=bucket,
            Key=obj,
            Tagging={
                "TagSet": [{"Key": k, "Value": v} for k, v in tag_map.items()]
            }
        )

        logger.info(f"Labeled sensitive object: {bucket}/{obj}")

    except Exception as e:
        logger.error(f"Failed to tag object {bucket}/{obj}: {e}")
        raise
