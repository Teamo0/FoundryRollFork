// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract InvariantHandler is CommonBase, StdCheats, StdUtils {

    uint256 public calledRollFork;

    function rollFork() public {
        vm.rollFork(block.number + 1);
        calledRollFork += 1;
    }

}

contract InvariantTest is Test {

    uint256 constant initialBlock = 16730733;

    InvariantHandler handler;

    function setUp() public {
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/zMB1JH4fW5QX6YjQ88QesuB6vRhCOKeD", initialBlock);
        handler = new InvariantHandler();
    }

    function invariant_blocknumber() public {
        assertEq(block.number, initialBlock);
    }

    function invariant_calledRollFork() public {
        assertEq(handler.calledRollFork(), 0);
    }

    function test_rollForkHandlerContract() public {
        assertEq(block.number, initialBlock);
        handler.rollFork();
        assertEq(block.number, initialBlock + 1);
    }

    function test_rollForkTestContract() public {
        assertEq(block.number, initialBlock);
        vm.rollFork(block.number + 1);
        assertEq(block.number, initialBlock + 1);
    }

}
