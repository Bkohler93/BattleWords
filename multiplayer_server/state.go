package main

import (
	"encoding/json"

	"github.com/Jeffail/gabs"
)

type MultiplayerState interface {
	MatchmakingState | SetupState /*| InGameState */
	ToJson() string
	StatusString() string
}

type ServerGameState[T MultiplayerState] struct {
	Phase MultiplayerPhase
	State T
}

func (s ServerGameState[MatchmakingState]) JsonBlob() []byte {
	gabs := gabs.New()

	gabs.Set(s.Phase.String(), "phase")
	gabs.Set(s.State.StatusString(), "status")
	gabs.Set(s.State.ToJson(), "data")

	return gabs.Bytes()
}

type MultiplayerPhase uint8

const (
	Matchmaking MultiplayerPhase = iota + 1
	Setup
	InGame
)

var (
	MultiplayerPhase_name = map[uint8]string{
		1: "matchmaking",
		2: "setup",
		3: "inGame",
	}
	MultiplayerPhase_value = map[string]uint8{
		"matchmaking": 1,
		"setup":       2,
		"inGame":      3,
	}
)

func (m MultiplayerPhase) String() string {
	return MultiplayerPhase_name[uint8(m)]
}

type ServerMatchmakingStatus uint8

const (
	MatchmakingConnectionError ServerMatchmakingStatus = iota + 1
	FindingGame
	GameFound
	Ready
	AwaitingOpponentReady
	OpponentDeclined
	EndMatchmaking
	Authenticate
)

var (
	ServerMatchmakingStatus_name = map[uint8]string{
		1: "matchmakingConnectionError",
		2: "findingGame",
		3: "gameFound",
		4: "ready",
		5: "awaitingOpponentReady",
		6: "opponentDeclined",
		7: "endMatchmaking",
		8: "authenticate",
	}
	ServerMatchmakingStatus_value = map[string]uint8{
		"matchmakingConnectionError": 1,
		"findingGame":                2,
		"gameFound":                  3,
		"ready":                      4,
		"awaitingOpponentReady":      5,
		"opponentDeclined":           6,
		"endMatchmaking":             7,
		"authenticate":               8,
	}
)

func (s ServerMatchmakingStatus) String() string {
	return ServerMatchmakingStatus_name[uint8(s)]
}

type MatchmakingState struct {
	Status ServerMatchmakingStatus
	Data   json.RawMessage
}

func (m MatchmakingState) ToJson() string {
	return ""
}

func (m MatchmakingState) StatusString() string {
	return m.Status.String()
}

type SetupStatus uint8

const (
	SetupFailed SetupStatus = iota + 1
	SetupOpponentTimeout
	Start
)

var (
	SetupStatus_name = map[uint8]string{
		1: "setupFailed",
		2: "setupOpponentTimeout",
		3: "start",
	}
	SetupStatus_value = map[string]uint8{
		"setupFailed":          1,
		"setupOpponentTimeout": 2,
		"start":                3,
	}
)

func (s SetupStatus) String() string {
	return SetupStatus_name[uint8(s)]
}

type SetupState struct {
	Status SetupStatus
	Data   json.RawMessage
}
