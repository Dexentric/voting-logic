//SPDX-License-Identifier:Unlicensed
pragma solidity 0.8.17;

library VoteLibrary
{
    struct Vote
    {
        uint id;
        uint time;
        string PartyName;
        string idnumber;
        string constituency;
    }
    struct Party
    {
        string name;
        uint voteCount;
    }
    struct Identity
    {
        string add;
        string Idnumber;
        string email;
    }
}