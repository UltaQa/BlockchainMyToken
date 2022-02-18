
pragma solidity ^0.5.0;
import "./Token.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";



//TODO:
//[x] Set the fee amount
//[x] Deposit Ether
//[x] Withdraw Eether
//[x] Deposit tokens
//[x] Withdraw tokens
//[x] Check balances
//[] Make order
//[] Cancel order
//[] Fill order
//[] Charge fees

contract Exchange {

	// Variables

	using SafeMath for uint;
	address public feeAccount; // the account that receives exchange
	uint256 public feePercent; // the fee percentage
	address constant ETHER = address(0); // store Ether in tokens mapping with blank address

	//mapping(address => uint256) public balanceOf;
	mapping(address => mapping(address => uint256)) public tokens;

	// Events

	event Deposit(address token, address user, uint256 amount, uint256 balance);
	event Withdraw(address token, address user, uint amount, uint balance);
		

	constructor(address _feeAccount, uint256 _feePercent) public {
		feeAccount = _feeAccount;
		feePercent = _feePercent;
	}

	// fallback: reverts if ether is sent directly to this exchange
	
	function() external {
		revert();
	}

	function depositEther() payable public {
		tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].add(msg.value);
		emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);

	}

	function withdrawEther(uint _amount) public {
		require(tokens[ETHER][msg.sender] >= _amount);
		tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].sub(_amount);
		msg.sender.transfer(_amount);
		emit Withdraw(ETHER, msg.sender, _amount, tokens[ETHER][msg.sender]);

	}



	function depositToken(address _token, uint _amount) public {
		require(_token != ETHER);
		require(Token(_token).transferFrom(msg.sender, address(this), _amount));
		tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount);
		emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
		// Manange depoit - update balance
		// Emit event

	}

	function withdrawToken(address _token, uint256 _amount) public {
		require(_token != ETHER);
		require(tokens[_token][msg.sender] >= _amount);
		tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);
		require(Token(_token).transfer(msg.sender, _amount));
		emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
	}

	function balanceOF(address _token, address _user) public view returns (uint256) {
		return tokens[_token][_user];


	}

}


// Deposit & withdraw funds
// Manage orders -- make or cancel
// Handle trades -- charge fees