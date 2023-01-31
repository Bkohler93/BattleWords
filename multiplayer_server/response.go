package main

import (
	"encoding/json"
	"fmt"
)

/// Contains states that will be sent to players during each stage of matchmaking/setup/in-game

func startGame() []byte {
	return []byte("{'status':'startingGame'}")
}

type ServerResponse struct {
	phase  string
	result string
	data   map[string]string
}

func newServerResponse(phase string, result string, data map[string]string) *ServerResponse {
	return &ServerResponse{
		phase:  phase,
		result: result,
		data:   data,
	}
}

func serverResponseToJson(s *ServerResponse) string {
	dataStr, err := json.Marshal(s.data)
	if err != nil {
		fmt.Println("error:", err)
	}

	return fmt.Sprintf("{'phase': '%s', 'status': '%s', 'data': '%s'}", s.phase, s.result, dataStr)
}
