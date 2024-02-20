// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

import {GetMyGho} from "../contracts/GetMyGho.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new GetMyGho();
        vm.stopBroadcast();
    }
}

contract DryRun is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        GetMyGho swapper = new GetMyGho();
        address origin = vm.envAddress("ORIGIN");
        bytes memory permit= vm.envBytes("PERMIT");
        uint256 permitDeadline = vm.envUint("PERMIT_DEADLINE");
        uint256 amountOut = swapper.execute(origin, permit, permitDeadline);
        console2.log(amountOut);

        vm.stopBroadcast();
    }
}

contract Execute is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address payable deployed = payable(vm.envAddress("GETMYGHO"));
        GetMyGho swapper = GetMyGho(deployed);
        address origin = vm.envAddress("ORIGIN");
        bytes memory permit= vm.envBytes("PERMIT");
        uint256 permitDeadline = vm.envUint("PERMIT_DEADLINE");
        uint256 amountOut = swapper.execute(origin, permit, permitDeadline);
        console2.log(amountOut);

        vm.stopBroadcast();
    }
}
