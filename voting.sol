// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ballot {
    
    
     //VARIABLES
     struct vote {
         address voterAddress ;
         bool choice ;
     }
     
     struct voter {
         string voterName ;
         bool voted ; //this is for if the voter voted or not 
     }
     
     uint private countResult = 0 ;
     uint public finalResult = 0 ; 
     uint public totalVoter = 0 ;
     uint public totalVote = 0 ;
     
     address public ballotOfficialAddress ; 
     string public ballotOfficialName ;
     string public proposal; 
     
     mapping(uint => vote ) private votes;
     mapping(address=> voter) public voterRegister ;
     
     
     enum State  { Created , Voting ,Ended }
     State public state ;
     
     
     
     //MODIFIERS 
     modifier condition(bool _condition) {
         require (_condition);
         _;
     }
     
     modifier onlyOfficial(){
        require( msg.sender== ballotOfficialAddress,"You are not eligible");      //only ballotOfficialAddress can call this 
        _;
     }
     
     modifier inState(State _state){
         require(state == _state);      // allow us to pass state of the contract  
         _;
     }
     
     // FUNCTIONS
     constructor
     (
         string memory _ballotOfficialName,
         string memory _proposal
     )
         {
        ballotOfficialAddress = msg.sender;
        ballotOfficialName = _ballotOfficialName;
        proposal = _proposal ;
        
       state = State.Created ;
     }
     
     function addVoter(address _voterAddress, string memory _voterName) // this function is to add voters
     public 
     inState(State.Created)
     onlyOfficial
     {
         voter memory v;
         v.voterName = _voterName;
         v.voted = false ;
         voterRegister[_voterAddress] = v;
         totalVoter++;
     }
     
     function startVote ()      //this function is to start the voting process 
     public
     inState(State.Created)
     onlyOfficial
     {
        state = State.Voting ; 
     }
     
     function doVote (bool _choice )  //this function is to caste a vote 
     public                          
     inState(State.Voting)
     returns (bool voted)
     {      
         bool found = false ;
         
         if (bytes(voterRegister[msg.sender].voterName).length !=0   // to get the length we need to write bytes function
         && !voterRegister[msg.sender].voted)                        //by this line  // do vote is only possible when the voter is registerd 
         {
             voterRegister[msg.sender].voted = true;
             vote memory v;
             v.choice = _choice;
             if (_choice) {
                 countResult++;
             }
             votes[totalVoter] = v;
             totalVote++;
             found = true;
         }
         return found;
     }
     
     function endVote() public    //this finction is to end the voting process 
        inState(State.Voting)     //can end voting only when the voting is running 
        onlyOfficial
         {
             state = State.Ended;
             finalResult = countResult ; // this step is helpful for accessing the result // it was stored in the private variable before 
                                           // so unable to access until we store its value in finalResult a public variable accesible to anyone after vting process 
         }
     
     
     
     
}
