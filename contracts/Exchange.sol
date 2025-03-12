// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Exchange {
    address public tokenAddress;
    uint public totalLiquidityPositions;
    mapping(address => uint) public liquidityPositions;
    uint private contractEthBalance;
    uint private contractTokenBalance;

    event LiquidityProvided(uint amountERC20TokenDeposited, uint amountEthDeposited, uint liquidityPositionsIssued);
    event LiquidityWithdrew(uint amountERC20TokenWithdrew, uint amountEthWithdrew, uint liquidityPositionsBurned);
    event SwapForEth(uint amountERC20TokenDeposited, uint amountEthWithdrew);
    event SwapForERC20Token(uint amountERC20TokenWithdrew, uint amountEthDeposited);

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    function provideLiquidity(uint _amountERC20Token) external payable returns (uint liquidityPositionsIssued) {
        require(msg.value > 0 && _amountERC20Token > 0, "Must provide ETH and ERC-20 token");
        ERC20 token = ERC20(tokenAddress);
        require(token.transferFrom(msg.sender, address(this), _amountERC20Token), "Transfer failed");
        
        if (totalLiquidityPositions == 0) {
            liquidityPositions[msg.sender] = 100;
            totalLiquidityPositions = 100;
        } else {
            liquidityPositionsIssued = (totalLiquidityPositions * _amountERC20Token) / contractTokenBalance;
            liquidityPositions[msg.sender] += liquidityPositionsIssued;
            totalLiquidityPositions += liquidityPositionsIssued;
        }

        contractEthBalance += msg.value;
        contractTokenBalance += _amountERC20Token;

        emit LiquidityProvided(_amountERC20Token, msg.value, liquidityPositionsIssued);
        return liquidityPositionsIssued;
    }

    function estimateEthToProvide(uint _amountERC20Token) external view returns (uint) {
        return (contractEthBalance * _amountERC20Token) / contractTokenBalance;
    }

    function estimateERC20TokenToProvide(uint _amountEth) external view returns (uint) {
        return (contractTokenBalance * _amountEth) / contractEthBalance;
    }

    function getMyLiquidityPositions() external view returns (uint) {
        return liquidityPositions[msg.sender];
    }

    function withdrawLiquidity(uint _liquidityPositionsToBurn) external returns (uint, uint) {
        require(_liquidityPositionsToBurn > 0 && _liquidityPositionsToBurn <= liquidityPositions[msg.sender], "Invalid amount");
        uint amountEthToSend = (contractEthBalance * _liquidityPositionsToBurn) / totalLiquidityPositions;
        uint amountERC20ToSend = (contractTokenBalance * _liquidityPositionsToBurn) / totalLiquidityPositions;
        
        liquidityPositions[msg.sender] -= _liquidityPositionsToBurn;
        totalLiquidityPositions -= _liquidityPositionsToBurn;
        contractEthBalance -= amountEthToSend;
        contractTokenBalance -= amountERC20ToSend;
        
        payable(msg.sender).transfer(amountEthToSend);
        ERC20(tokenAddress).transfer(msg.sender, amountERC20ToSend);
        
        emit LiquidityWithdrew(amountERC20ToSend, amountEthToSend, _liquidityPositionsToBurn);
        return (amountERC20ToSend, amountEthToSend);
    }

    function swapForEth(uint _amountERC20Token) external returns (uint) {
        require(_amountERC20Token > 0, "Must provide tokens");
        uint contractERC20TokenBalanceAfterSwap = contractTokenBalance + _amountERC20Token;
        uint contractEthBalanceAfterSwap = (contractEthBalance * contractTokenBalance) / contractERC20TokenBalanceAfterSwap;
        uint ethToSend = contractEthBalance - contractEthBalanceAfterSwap;

        ERC20(tokenAddress).transferFrom(msg.sender, address(this), _amountERC20Token);
        payable(msg.sender).transfer(ethToSend);
        contractTokenBalance += _amountERC20Token;
        contractEthBalance -= ethToSend;

        emit SwapForEth(_amountERC20Token, ethToSend);
        return ethToSend;
    }

    function estimateSwapForEth(uint _amountERC20Token) external view returns (uint) {
        uint contractERC20TokenBalanceAfterSwap = contractTokenBalance + _amountERC20Token;
        uint contractEthBalanceAfterSwap = (contractEthBalance * contractTokenBalance) / contractERC20TokenBalanceAfterSwap;
        return contractEthBalance - contractEthBalanceAfterSwap;
    }

    function swapForERC20Token() external payable returns (uint) {
        require(msg.value > 0, "Must provide ETH");
        uint contractEthBalanceAfterSwap = contractEthBalance + msg.value;
        uint contractERC20TokenBalanceAfterSwap = (contractTokenBalance * contractEthBalance) / contractEthBalanceAfterSwap;
        uint tokensToSend = contractTokenBalance - contractERC20TokenBalanceAfterSwap;

        ERC20(tokenAddress).transfer(msg.sender, tokensToSend);
        contractEthBalance += msg.value;
        contractTokenBalance -= tokensToSend;

        emit SwapForERC20Token(tokensToSend, msg.value);
        return tokensToSend;
    }

    function estimateSwapForERC20Token(uint _amountEth) external view returns (uint) {
        uint contractEthBalanceAfterSwap = contractEthBalance + _amountEth;
        uint contractERC20TokenBalanceAfterSwap = (contractTokenBalance * contractEthBalance) / contractEthBalanceAfterSwap;
        return contractTokenBalance - contractERC20TokenBalanceAfterSwap;
    }
}