const hre = require("hardhat");

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const unlockTime = currentTimestampInSeconds + 60;

  // const lockedAmount = hre.ethers.parseEther("0.001");

  // const lock = await hre.ethers.deployContract("BBNFT", [unlockTime], {
  //   value: lockedAmount,
  // });

  // await lock.waitForDeployment();



  // console.log(
  //   `Lock with ${ethers.formatEther(
  //     lockedAmount
  //   )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.target}`
  // );



  const BBNFT = await hre.ethers.getContractFactFactory("BBNFT");
  const bbNFT = await BBNFT.deploy();

  await bbNFT.deployed();

  console.log("BBNFT deployed to:", bbNFT.address);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
