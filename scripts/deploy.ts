import { ethers } from 'ethers'
import { deploy } from './ethers-lib'

async function main() {
  console.log('Main starting')
  const gameContract = await deploy('Game', [Math.floor(Math.random() * 100)]);
  await console.log('deployed')
  

  gameContract.on("GameWon", async (winner: string, reward: ethers.BigNumber) => {
    console.log(`Game won by ${winner}. Reward: ${ethers.utils.formatEther(reward)} ETH`);

    const newTarget = Math.floor(Math.random() * 100);
    console.log(`Setting new target to ${newTarget}`);

    try {
      const tx = await gameContract.setTarget(newTarget);
      console.log(`Transaction hash: ${tx.hash}`);

      await tx.wait();
      console.log("Target successfully set!");
    } catch (error) {
      console.error("Failed to set target:", error);
    }
  });
}

main().catch((error) => {
  console.error("Error in script execution:", error.message);
});