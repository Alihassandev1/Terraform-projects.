resource "aws_cloudwatch_log_group" "app" {
  name              = "/linkedops/application"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "system" {
  name              = "/linkedops/system"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
}

resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_dashboard" "app" {
  dashboard_name = "${var.environment}-linkedops"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        width  = 12
        height = 6

        properties = {
          title  = "EC2 CPU Utilization"
          region = "us-east-1"

          metrics = [
            ["AWS/EC2", "CPUUtilization"]
          ]

          period = 300
          stat   = "Average"
        }
      },
      {
        type   = "metric"
        width  = 12
        height = 6

        properties = {
          title  = "EC2 Network Traffic"
          region = "us-east-1"

          metrics = [
            ["AWS/EC2", "NetworkIn", "AutoScalingGroupName", var.autoscaling_group_name],
            ["AWS/EC2", "NetworkOut", "AutoScalingGroupName", var.autoscaling_group_name],
            [".", "NetworkOut", ".", "."]
          ]

          period = 300
          stat   = "Average"
        }
      }
    ]
  })
}