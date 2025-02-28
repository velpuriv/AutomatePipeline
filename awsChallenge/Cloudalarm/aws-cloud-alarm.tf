# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "cpu-alert-topic"
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "This metric monitors high CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
}



# CloudTrail
resource "aws_cloudtrail" "main" {
  name           = "my-cloudtrail"
  s3_bucket_name = var.s3_bucket_name
}