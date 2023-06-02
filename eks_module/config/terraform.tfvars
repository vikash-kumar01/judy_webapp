
aws_eks_cluster_config = {

      "demo-cluster" = {

        eks_cluster_name         = "demo-cluster"
        eks_subnet_ids = ["subnet-095fbec41ceadefd0","subnet-09de5082ede7a1706","subnet-0085fee539a663744","subnet-0c1d164ad628d2a35"]
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
        node_subnet_ids          =  ["subnet-095fbec41ceadefd0","subnet-09de5082ede7a1706","subnet-0085fee539a663744","subnet-0c1d164ad628d2a35"]
        tags = {
             "Name" =  "node"
         } 
  }
}