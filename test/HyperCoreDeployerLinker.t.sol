// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { PermissionedSalt } from "deterministic-proxy-factory/PermissionedSalt.sol";
import {
    DeterministicProxyFactoryFixture,
    MINIMAL_UUPS_UPGRADEABLE_ADDRESS
} from "deterministic-proxy-factory/fixtures/DeterministicProxyFactoryFixture.sol";
import { Test } from "forge-std/Test.sol";
import { HyperCoreDeployerLinker } from "src/HyperCoreDeployerLinker.sol";

contract HyperCoreDeployerLinkerTest is Test {

    HyperCoreDeployerLinker impl;
    address hyperCoreDeployer;
    address proxy;

    event Upgraded(address indexed newImplementation);

    function setUp() public {
        impl = new HyperCoreDeployerLinker();
        hyperCoreDeployer = makeAddr("hyperCoreDeployer");
        proxy = DeterministicProxyFactoryFixture.deterministicProxyUUPS(
            PermissionedSalt.create(address(this), 0), address(impl), ""
        );
    }

    function test_setDeployerAndUpgradeToAndCall_emitsHyperCoreDeployerSet() public {
        vm.expectEmit(true, false, false, false);
        emit HyperCoreDeployerLinker.HyperCoreDeployerSet(hyperCoreDeployer);

        HyperCoreDeployerLinker(proxy)
            .setDeployerAndUpgradeToAndCall(hyperCoreDeployer, address(impl), "");
    }

    function testFuzz_setDeployerAndUpgradeToAndCall_emitsHyperCoreDeployerSet(address deployer)
        public
    {
        vm.assume(deployer != address(0));
        address newImplementation = address(new HyperCoreDeployerLinker());

        vm.expectEmit(true, false, false, false);
        emit HyperCoreDeployerLinker.HyperCoreDeployerSet(deployer);

        vm.expectEmit(true, true, true, true);
        emit Upgraded(newImplementation);

        HyperCoreDeployerLinker(proxy)
            .setDeployerAndUpgradeToAndCall(deployer, newImplementation, "");
    }

}

