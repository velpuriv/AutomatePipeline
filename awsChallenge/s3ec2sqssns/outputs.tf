output "s3_bucket_name" {
  value = aws_s3_bucket.static_assets.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.app_notifications.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.app_queue.id
}


