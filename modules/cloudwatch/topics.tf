# SNS topic for notifications
resource "aws_sns_topic" "cloudwatch_alerts" {
  name = "cloudwatch-alerts"
}

# Subscribe to our email newsletter
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.cloudwatch_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
