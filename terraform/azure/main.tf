module "network" {
 source = "./modules/network"
}

module "compute" {
 source = "./modules/compute"
  rg_name = module.network.rgname
  location = module.network.location
  vnet10 = module.network.vnet10
  subnet_vnet10a = module.network.subnet_vnet10a
  subnet_vnet10b = module.network.subnet_vnet10b
}
