
aws_eks_cluster_config = {

      "demo-cluster" = {

        eks_cluster_name         = "demo-cluster"
        eks_subnet_ids = ["subnet-01baa9542c01ccdbc","subnet-087a3ff2ba89841a1","subnet-04cf0b74ac2d920cb","subnet-0fb1040014c997d65"]
        tags = {
             "Name" =  "demo-cluster"
         }  
      }
}

eks_node_group_config = {

  "node1" = {

        eks_cluster_name         = "demo-cluster"
        node_group_name          = "mynode"
        nodes_iam_role           = "eks-node-group-general"
        node_subnet_ids          = ["subnet-01baa9542c01ccdbc","subnet-087a3ff2ba89841a1","subnet-04cf0b74ac2d920cb","subnet-0fb1040014c997d65"]

        tags = {
             "Name" =  "node"
         } 
  }
}