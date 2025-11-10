global_tags = { owner:"josue", "env" : "dev" }
stack_number         = "01"
prefix_resource_name = "proyect"
is_production        = false

network = {
  azs                = ["us-east-1a", "us-east-1b"]
  vpc_cidr           = "172.20.0.0/16"
  public_subnets     = ["172.20.10.0/24", "172.20.20.0/24"]
  private_subnets    = ["172.20.30.0/24", "172.20.40.0/24"]
  restricted_subnets = ["172.20.50.0/24", "172.20.60.0/24"]
}






