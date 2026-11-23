variable "secret_arn" {
  type = string
}

variable "policy_arns" {
  description = "Managed IAM policies to attach to the EC2 role"
  type        = set(string)

  default = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}