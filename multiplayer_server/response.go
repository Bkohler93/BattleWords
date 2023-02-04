package main

import (
	"encoding/json"
	"fmt"
	"strings"
)

// / Contains states that will be sent to players during each stage of matchmaking/setup/in-game
func startGame() []byte {
	return []byte("{'status':'startingGame'}")
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

// Convert a string to a MultiplayerPhase, returns an error if the string is unknown.
// NOTE: for JSON marshaling this must return a MultiplayerPhase value not a pointer, which is
// common when using integer enumerations (or any primitive type alias).
func ParseMultiplayerPhase(s string) (MultiplayerPhase, error) {
	s = strings.TrimSpace(strings.ToLower(s))
	value, ok := MultiplayerPhase_value[s]
	if !ok {
		return MultiplayerPhase(0), fmt.Errorf("%q is not a valid multiplayer phase", s)
	}
	return MultiplayerPhase(value), nil
}

func (m MultiplayerPhase) MarshalJSON() ([]byte, error) {
	return json.Marshal(m.String())
}

// UnmarshalJSON must be a *pointer receiver* to ensure that the indirect from the
// parsed value can be set on the unmarshaling object. This means that the
// ParseSuit function must return a *value* and not a pointer.
func (m *MultiplayerPhase) UnmarshalJSON(data []byte) (err error) {
	var suits string
	if err := json.Unmarshal(data, &suits); err != nil {
		return err
	}
	if *m, err = ParseMultiplayerPhase(suits); err != nil {
		return err
	}
	return nil
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
	}
	ServerMatchmakingStatus_value = map[string]uint8{
		"matchmakingConnectionError": 1,
		"findingGame":                2,
		"gameFound":                  3,
		"ready":                      4,
		"awaitingOpponentReady":      5,
		"opponentDeclined":           6,
		"endMatchmaking":             7,
	}
)

func (s ServerMatchmakingStatus) String() string {
	return ServerMatchmakingStatus_name[uint8(s)]
}

// Convert a string to a ServerMatchmakingStatus, returns an error if the string is unknown.
// NOTE: for JSON marshaling this must return a ServerMatchmakingStatus value not a pointer, which is
// common when using integer enumerations (or any primitive type alias).
func ParseServerMatchmakingStatus(s string) (ServerMatchmakingStatus, error) {
	s = strings.TrimSpace(strings.ToLower(s))
	value, ok := ServerMatchmakingStatus_value[s]
	if !ok {
		return ServerMatchmakingStatus(0), fmt.Errorf("%q is not a valid matchmaking status", s)
	}
	return ServerMatchmakingStatus(value), nil
}

func (s ServerMatchmakingStatus) MarshalJSON() ([]byte, error) {
	return json.Marshal(s.String())
}

// UnmarshalJSON must be a *pointer receiver* to ensure that the indirect from the
// parsed value can be set on the unmarshaling object. This means that the
// ParseSuit function must return a *value* and not a pointer.
func (s *ServerMatchmakingStatus) UnmarshalJSON(data []byte) (err error) {
	var suits string
	if err := json.Unmarshal(data, &suits); err != nil {
		return err
	}
	if *s, err = ParseServerMatchmakingStatus(suits); err != nil {
		return err
	}
	return nil
}

type ServerResponse struct {
	Phase  MultiplayerPhase        `json:"phase"`
	Status ServerMatchmakingStatus `json:"status"`
	Data   map[string]string       `json:"data"`
}

func newServerResponse(phase MultiplayerPhase, status ServerMatchmakingStatus, data map[string]string) *ServerResponse {
	return &ServerResponse{
		Phase:  phase,
		Status: status,
		Data:   data,
	}
}

func serverResponseToJson(s *ServerResponse) string {
	dataStr, err := json.Marshal(s.Data)
	if err != nil {
		fmt.Println("error:", err)
	}

	fmt.Println(dataStr)

	return fmt.Sprintf("{'phase': '%s', 'status': '%s', 'data': '%s'}", s.Phase, s.Status, dataStr)
}
