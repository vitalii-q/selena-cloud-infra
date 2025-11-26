resource "aws_cloudwatch_log_metric_filter" "users_service_errors" {
  name           = "UsersServiceErrorFilter"
  log_group_name = aws_cloudwatch_log_group.users_service_logs.name
  pattern        = "ERROR"

  metric_transformation {
    name      = "UsersServiceErrors"
    namespace = "Selena"
    value     = "1"
  }

  depends_on = [aws_cloudwatch_log_group.users_service_logs]
}

resource "aws_cloudwatch_metric_alarm" "users_service_errors_alarm" {
  alarm_name          = "UsersServiceErrorsAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.users_service_errors.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.users_service_errors.metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_actions       = [var.alerts_topic_arn]
}
