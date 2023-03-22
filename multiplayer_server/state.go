package main

// ClientStateMatchmaking is the curent state of the matchmaking process received from the client.
type ClientStateMatchmaking struct {
	MatchmakingStep string
	ClientId        string
}

// ! from client. will require extra data, like the game board created / words that are placed
type ClientStateSetup struct {
	SetupStep string
	ClientID  string
}

// ! from client. Needs extra data, like the action taken (tile X uncovered, X word guessed, etc)
type ClientStateInGame struct {
	InGameStep string
	ClientID   string
}

// ServerStateMatchmaking is the current state of the matchmaking process sent to the client.
type ServerStateMatchmaking struct {
	MatchmakingStep string
}

// ! send to client. May not need extra data
type ServerStateSetup struct {
	SetupStep string
}

// ! send to client. client needs to know which player's turn it is and needs to send a view state of the game board
type ServerStateInGame struct {
	InGameStep string
}
