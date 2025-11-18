// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { HyperCoreDeployerLinker } from "../src/HyperCoreDeployerLinker.sol";
import { Script, console } from "forge-std/Script.sol";
import {
    UUPSUpgradeable
} from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Link is Script {

    function setUp() public { }

    function run() public {
        vm.createSelectFork(vm.rpcUrl("hyperliquid-evm-testnet"));
        address deployer = vm.envAddress("DEPLOYER");
        address target = vm.envAddress("TARGET");
        address hyperCoreDeployer = vm.envAddress("HYPERCORE_DEPLOYER");
        address linkerImpl = vm.envAddress("LINKER_IMPL");
        address currentImplementation = address(
            uint160(
                uint256(
                    vm.load(
                        target, 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
                    )
                )
            )
        );
        console.log("deployer", deployer);
        console.log("target", target);
        console.log("currentImplementation", currentImplementation);
        vm.startBroadcast(deployer);
        UUPSUpgradeable(target)
            .upgradeToAndCall(
                address(linkerImpl),
                abi.encodeCall(
                    HyperCoreDeployerLinker.setDeployerAndUpgradeToAndCall,
                    (hyperCoreDeployer, address(currentImplementation), "")
                )
            );

        vm.stopBroadcast();
    }

}
