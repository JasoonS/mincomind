import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const deployed = await deploy("Mincomind", {
    from: deployer,
    value: "1000000000000000",
    args: [],
    log: true,
  });

  console.log(`Mincomind contract: `, deployed.address);
};
export default func;
func.id = "deploy_Mincomind"; // id required to prevent reexecution
func.tags = ["Mincomind"];
