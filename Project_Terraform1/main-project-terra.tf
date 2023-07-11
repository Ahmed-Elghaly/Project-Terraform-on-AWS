
module "vpc-1" {
    source = "./vpc"
    vpc_cidr = "10.0.0.0/16"
    
}

module "subnet-priv1" {
    source = "./subnets"
    cider-block = "10.0.1.0/24"
    vpc-id = module.vpc-1.id
    status = false
    name = "subnet-private-1"
    av-zone = "us-east-1a"

}

module "subnet-priv2" {
    source = "./subnets"
    cider-block = "10.0.3.0/24"
    vpc-id = module.vpc-1.id
    status = false
    name = "subnet-private-2"
    av-zone = "us-east-1b"


}

module "subnet-pub1" {
    source = "./subnets"
    cider-block = "10.0.0.0/24"
    vpc-id = module.vpc-1.id
    status = true
    name = "subnet-public-1"
    av-zone = "us-east-1a"


}

module "subnet-pub2" {
    source = "./subnets"
    cider-block = "10.0.4.0/24"
    vpc-id = module.vpc-1.id
    status = true
    name = "subnet-public-2"
    av-zone = "us-east-1b"

}


module "gateway1" {
    source = "./gateway"
    ig-vpc-id = module.vpc-1.id
    name = "internet-gateway"
        
}

module "security-group1" {
    source = "./security-group"
    vpc-sec-id = module.vpc-1.id
    name = "security-g1"
    
}
module "ami" {
    source = "./data-source"

    
}
#create private instance
module "private-instance1" {
    source = "./private-instance"
    amiID = module.ami.ami-id
    subnet-pri = module.subnet-priv1.subnet-priv1
    status-sub = false
    sec-id = module.security-group1.id
    name-instance = "Private-EC2-1"
        
}

module "private-instance2" {
    source = "./private-instance"
    amiID = module.ami.ami-id
    subnet-pri = module.subnet-priv2.subnet-priv1
    status-sub = false
    sec-id = module.security-group1.id
    name-instance = "Private-EC2-2"
        
}

#create Nat 
module "nat-and-eip" {
    source = "./Nat-and-EIP"
    subnet-id = module.subnet-pub1.subnet-priv1
}

#create routing table public
module "routing-table-public" {
    source = "./routing-table"
    vpc-rid = module.vpc-1.id
    name-rt = "routing-table-public"
    gtw-id = module.gateway1.gtwID    
}

#create route table association to public
module "route-table-association-public1" {
    source = "./route-table-association"
    sub-id = module.subnet-pub1.subnet-priv1
    rt-id = module.routing-table-public.rtID
    
}

module "route-table-association-public2" {
    source = "./route-table-association"
    sub-id = module.subnet-pub2.subnet-priv1
    rt-id = module.routing-table-public.rtID
    
}

#create routing table private
module "routing-table-private" {
    source = "./routing-table-priv"
    vpc-rid-pri = module.vpc-1.id
    name-rt-pri = "routing-table-private"
    nat-id = module.nat-and-eip.natID    
}
#create route table association to private
module "route-table-association-private1" {
    source = "./route-table-association"
    sub-id = module.subnet-priv1.subnet-priv1
    rt-id = module.routing-table-private.rtpID
}

module "route-table-association-private2" {
    source = "./route-table-association"
    sub-id = module.subnet-priv2.subnet-priv1
    rt-id = module.routing-table-private.rtpID
}

module "public-instance1" {
    source = "./public-instance"
    AMI_ID = module.ami.ami-id
    sub-p-id = module.subnet-pub1.subnet-priv1
    sec-p-id = module.security-group1.id
    name-p = "public-instance1"

    dns-name = module.net-lb1.dns
    
}

module "public-instance2" {
    source = "./public-instance"
    AMI_ID = module.ami.ami-id
    sub-p-id = module.subnet-pub2.subnet-priv1
    sec-p-id = module.security-group1.id
    name-p = "public-instance2"

    dns-name = module.net-lb1.dns
    
}
#create public network load balancer
#create target group

module "target-g1" {
    source = "./Target-Group"
    vcp-tg-id = module.vpc-1.id
    name-tg = "target-g1"
    
}

module "register-g1" {
    source = "./Register-Targets"
    re-tg = module.target-g1.tg-arn
    re-inst-id = module.public-instance1.instance_id
    
}

module "register-g2" {
    source = "./Register-Targets"
    re-tg = module.target-g1.tg-arn
    re-inst-id = module.public-instance2.instance_id
    
}
#create network load balancer
module "net-lb1" {
    source = "./Network-Load-Balancer"
    nlb-sub1-id = module.subnet-pub1.subnet-priv1
    nlb-sub2-id = module.subnet-pub2.subnet-priv1
    ltg-arn = module.target-g1.tg-arn
    name-lb = "public-lb"
    state-lb = false    
    
}

#create private network load balancer

#create target group
module "target-g2" {
    source = "./Target-Group"
    vcp-tg-id = module.vpc-1.id
    name-tg = "target-g2"
    
}

module "register-g1-pri" {
    source = "./Register-Targets"
    re-tg = module.target-g2.tg-arn
    re-inst-id = module.private-instance1.instance_pri_id

    
}

module "register-g2-pri" {
    source = "./Register-Targets"
    re-tg = module.target-g2.tg-arn
    re-inst-id = module.private-instance2.instance_pri_id
    
}

#create network load balancer
module "net-lb2-pri" {
    source = "./Network-Load-Balancer"
    nlb-sub1-id = module.subnet-priv1.subnet-priv1
    nlb-sub2-id = module.subnet-priv2.subnet-priv1
    ltg-arn = module.target-g2.tg-arn
    name-lb = "private-lb"
    state-lb = true 
}