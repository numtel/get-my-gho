// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ISwapRouter.sol";
import "./IERC20Permit.sol";

contract GetMyGho {
  ISwapRouter public immutable swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
  IPriceFeed public immutable GHOUSD = IPriceFeed(0x3f12643D3f6f874d39C2a4c9f2Cd6f2DbAC877FC);
  IPriceFeed public immutable ETHUSD = IPriceFeed(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);

  address public constant GHO = 0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f;
  address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

  fallback() external payable {}
  receive() external payable {}

  function execute(
    address origin,
    bytes memory permit,
    uint256 permitDeadline
  ) external returns (uint256 amountOut) {
    IERC20Permit token = IERC20Permit(GHO);

    uint256 amountIn = token.balanceOf(origin);
    amountOut = amountIn;

    (bytes32 r, bytes32 s, uint8 v) = splitSignature(permit);
    token.permit(origin, address(this), amountIn, permitDeadline, v, r, s);

    token.transferFrom(origin, address(this), amountIn);

    token.approve(address(swapRouter), amountIn);

    uint256 amountOutMinimum = (amountIn * 1e8) / ((ETHUSD.latestAnswer() * 1e8) / GHOUSD.latestAnswer());

    // Allow some slippage
    amountOutMinimum *= 980;
    amountOutMinimum /= 1000;

    ISwapRouter.ExactInputParams memory params =
      ISwapRouter.ExactInputParams({
        path: abi.encodePacked(GHO, uint24(500), USDC, uint24(500), WETH9),
        recipient: address(this),
        deadline: block.timestamp,
        amountIn: amountIn,
        amountOutMinimum: amountOutMinimum
      });
    amountOut = swapRouter.exactInput(params);

    IWETH weth = IWETH(WETH9);
    weth.withdraw(amountOut);

    payable(msg.sender).transfer(0.07 ether);
    payable(origin).transfer(address(this).balance);
  }

  // From https://solidity-by-example.org/signature/
  function splitSignature(bytes memory sig) internal pure
    returns (bytes32 r, bytes32 s, uint8 v)
  {
    require(sig.length == 65, "invalid signature length");
    assembly {
        // first 32 bytes, after the length prefix
        r := mload(add(sig, 32))
        // second 32 bytes
        s := mload(add(sig, 64))
        // final byte (first byte of the next 32 bytes)
        v := byte(0, mload(add(sig, 96)))
    }
  }
}

interface IWETH is IERC20Permit {
  function withdraw(uint wad) external;
}

interface IPriceFeed {
   function latestAnswer() external view returns(uint256);
}
