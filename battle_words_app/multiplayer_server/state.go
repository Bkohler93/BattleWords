package main

import (
	"encoding/json"
	"fmt"
)

type MatchmakingStep string
type SetupStep string
type InGameStep string

const (
	MatchmakingStepAuthenticate          MatchmakingStep = "Authenticate"
	MatchmakingStepConnectionError       MatchmakingStep = "ConnectionError"
	MatchmakingStepFindingGame           MatchmakingStep = "FindingGame"
	MatchmakingStepGameFound             MatchmakingStep = "GameFound"
	MatchmakingStepReady                 MatchmakingStep = "Ready"
	MatchmakingStepAwaitingOpponentReady MatchmakingStep = "AwaitingOpponentReady"
	MatchmakingStepOpponentDeclined      MatchmakingStep = "OpponentDeclined"
	MatchmakingStepEndMatchmaking        MatchmakingStep = "EndMatchmaking"

	SetupStepInitial         SetupStep = "Initial"
	SetupStepError           SetupStep = "Error"
	SetupStepConnectionError SetupStep = "ConnectionError"
	SetupStepEndSetup        SetupStep = "EndSetup"
	SetupStepServerSaysHi    SetupStep = "ServerSaysHi"
	SetupStepClientSaysHi    SetupStep = "ClientSaysHi"

	//TODO implement enum values for InGameStep
)

func (e *MatchmakingStep) UnmarshalJSON(b []byte) error {
	var s string
	err := json.Unmarshal(b, &s)
	if err != nil {
		return err
	}

	switch MatchmakingStep(s) {
	case MatchmakingStepAuthenticate, MatchmakingStepConnectionError, MatchmakingStepFindingGame, MatchmakingStepGameFound, MatchmakingStepReady, MatchmakingStepAwaitingOpponentReady, MatchmakingStepEndMatchmaking:
		*e = MatchmakingStep(s)
		return nil
	default:
		return fmt.Errorf("invalid enum value: %s", s)
	}
}

func (e *SetupStep) UnmarshalJSON(b []byte) error {
	var s string
	err := json.Unmarshal(b, &s)
	if err != nil {
		return err
	}

	switch SetupStep(s) {
	case SetupStepInitial, SetupStepError, SetupStepConnectionError, SetupStepEndSetup, SetupStepServerSaysHi:
		*e = SetupStep(s)
		return nil
	default:
		return fmt.Errorf("invalid enum value: %s", s)
	}
}

//TODO implement Unmarshal interface for InGameStep

// ClientStateMatchmaking is the curent state of the matchmaking process received from the client.
type ClientStateMatchmaking struct {
	MatchmakingStep MatchmakingStep
	ClientId        string
}

// ! from client. will require extra data, like the game board created / words that are placed
type ClientStateSetup struct {
	SetupStep SetupStep
	ClientID  string
}

// ! from client. Needs extra data, like the action taken (tile X uncovered, X word guessed, etc)
type ClientStateInGame struct {
	InGameStep string
	ClientID   string
}

// ServerStateMatchmaking is the current state of the matchmaking process sent to the client.
type ServerStateMatchmaking struct {
	MatchmakingStep MatchmakingStep
	ClientId        string // client to send state to
	isSendToBoth    bool
}

// ! send to client. May not need extra data
type ServerStateSetup struct {
	SetupStep SetupStep
}

// ! send to client. client needs to know which player's turn it is and needs to send a view state of the game board
type ServerStateInGame struct {
	InGameStep string
}
