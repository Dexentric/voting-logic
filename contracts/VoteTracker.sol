pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;
import "./VoteLibrary.sol";

contract VoteTracker
{
    string public secret = "123456";

    mapping(uint => VoteLibrary.Vote) public VoteStore;
    uint256 public voterCount = 0;

    mapping(uint => VoteLibrary.Party) public PartyStore;
    uint256 public partyCount = 0;

    mapping(uint => VoteLibrary.Identity) public IdentityStore;
    uint256 public identityCount = 0;

    function registerUser(string memory _add, string memory idnumber, string memory _email) public returns(uint256)
    {
        require(checkIfAccCanExist(_add));
        require(checkIfIdCanExist(idnumber));
        identityCount++;
        IdentityStore[identityCount] = VoteLibrary.Identity(_add,idnumber,_email);
        emit IdentityCreate(_add,idnumber,_email);
    }

    function generateVote(string memory _ID, string memory _partyName, string memory ID, string memory _constituency) public returns(uint256)
    {
        require(!checkIfAccCanExist(_ID));
        require(!checkIfIdCanExist(ID));
        require(checkIfCanVote(ID));
        require(!checkIfCanExist(_partyName));
        voterCount++;
        VoteStore[voterCount] = VoteLibrary.Vote(voterCount, block.timestamp, _partyName, ID, _constituency);
        uint partyIndex = getParty(_partyName);
        PartyStore[partyIndex].voteCount++;
        emit VoteGenerate(voterCount, block.timestamp, _partyName, ID, _constituency);
    }
    
    function createParty(string memory _name) public returns(uint256)
    {
        require(checkIfCanExist(_name));
        partyCount++;
        PartyStore[partyCount] = VoteLibrary.Party(_name, 0);
        emit PartyCreate(_name, 0);
    }

    function getAdminKey() public returns(string memory)
    {
        return secret;
    }

    function checkIfCanExist(string memory _namer) private returns(bool)
    {
        for(uint i=1;i<=partyCount;i++)
        {
            string memory partyNamed = PartyStore[i].name;
            if(keccak256(abi.encodePacked((partyNamed))) == keccak256(abi.encodePacked((_namer))))
            {
                return false;
            }
        }
        return true;
    }

    function checkIfIdCanExist(string memory _namered) private returns(bool)
    {
        for(uint i=1;i<=identityCount;i++)
        {
            string memory idNamed = IdentityStore[i].Idnumber;
            if(keccak256(abi.encodePacked((idNamed))) == keccak256(abi.encodePacked((_namered))))
            {
                return false;
            }
        }
        return true;
    }

    function checkIfAccCanExist(string memory _namerer) private returns(bool)
    {
        for(uint i=1;i<=identityCount;i++)
        {
            string memory idNamed = IdentityStore[i].add;
            if(keccak256(abi.encodePacked((idNamed))) == keccak256(abi.encodePacked((_namerer))))
            {
                return false;
            }
        }
        return true;
    }

    function checkIfCanVote(string memory _adhaarer) private returns(bool)
    {
        for(uint i=1;i<=voterCount;i++)
        {
            string memory voteNamed = VoteStore[i].idnumber;
            if(keccak256(abi.encodePacked((voteNamed))) == keccak256(abi.encodePacked((_adhaarer))))
            {
                return false;
            }
        }
        return true;
    }

    function getParty(string memory _partyNamer) private returns (uint)
    {
        for(uint i=1;i<=partyCount;i++)
        {
            string memory partyNamed = PartyStore[i].name;
            if(keccak256(abi.encodePacked((partyNamed))) == keccak256(abi.encodePacked((_partyNamer))))
            {
                return i;
            }
        }
    }

    function getPartyCount() public returns (uint)
    {
        return partyCount;
    }

    function getNames(uint _id) public returns(uint,string memory)
    {
        require(_id<=partyCount);
        return (PartyStore[_id].voteCount,PartyStore[_id].name);
    }

    event IdentityCreate(string add, string Idnumber, string email);
    event PartyCreate(string name, uint voteCount);
    event VoteGenerate(uint voteCount, uint time, string partyName, string adhaar, string constituency);
}