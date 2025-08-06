// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract HyperCoreLinker is UUPSUpgradeable {

    bytes32 constant HYPER_CORE_DEPLOYER_SLOT = keccak256("HyperCore deployer");

    function setDeployerAndUpgradeToAndCall(
        address hyperCoreDeployer,
        address newImplementation,
        bytes calldata data
    ) external {
        bytes32 hyperCoreDeployerSlot = HYPER_CORE_DEPLOYER_SLOT;
        assembly {
            sstore(hyperCoreDeployerSlot, hyperCoreDeployer)
        }
        upgradeToAndCall(newImplementation, data);
    }

    function _authorizeUpgrade(address newImplementation) internal override { }

}
