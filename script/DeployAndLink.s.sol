// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { HyperCoreLinker } from "../src/HyperCoreLinker.sol";
import { Script, console } from "forge-std/Script.sol";
import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract DeployAndLink is Script {

    function setUp() public { }

    function run() public {
        vm.createSelectFork(vm.rpcUrl("hyperliquid_evm"));
        address deployer = vm.envAddress("DEPLOYER");
        address target = vm.envAddress("TARGET");
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
        HyperCoreLinker impl = new HyperCoreLinker{ salt: bytes32(0) }();
        // UUPSUpgradeable(target).upgradeToAndCall(
        //     address(impl),
        //     abi.encodeCall(
        //         HyperCoreLinker.setDeployerAndUpgradeToAndCall, (deployer, address(impl), "")
        //     )
        // );

        vm.stopBroadcast();
    }

}
