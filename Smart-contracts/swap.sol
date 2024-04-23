// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

contract SwapExamples {
   

    ISwapRouter public immutable swapRouter;


    address public constant DAI = 0x6B41C8977a438Ca4664B6a10D273a38c3f61b4b1;
    address public constant WETH9 = 0xC04a3786d42f71724Ba2b7B5Ab97f58ed58815a3;
    address public constant USDC = 0xA0988F38F32bd623e9ae2E88882428F8E303e689;


    uint24 public constant poolFee = 3000;

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }

    function swapExactInputSingle(uint256 amountIn) external returns (uint256 amountOut) {
   

     
        TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), amountIn);


        TransferHelper.safeApprove(DAI, address(swapRouter), amountIn);

    
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: WETH9,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });


        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapExactOutputSingle(uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {

        TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), amountInMaximum);

      
        TransferHelper.safeApprove(DAI, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: DAI,
                tokenOut: WETH9,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });


        amountIn = swapRouter.exactOutputSingle(params);

       
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(DAI, address(swapRouter), 0);
            TransferHelper.safeTransfer(DAI, msg.sender, amountInMaximum - amountIn);
        }
    }
}