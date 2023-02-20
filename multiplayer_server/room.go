package main

import (
	"encoding/json"
	"fmt"

	"github.com/Jeffail/gabs"
)

type Room struct {
	client_one *Client
	client_two *Client
	game       *Game

	process chan []byte // receive from clients to process a GameAction made by client
	place   chan *Client
	remove  chan *Client

	hub *Hub

	isOpen bool //* guessing that this will be needed, may not be.
}

func newRoom(hub *Hub) *Room {
	return &Room{
		client_one: nil,
		client_two: nil,
		game:       newGame(),
		process:    make(chan []byte),
		place:      make(chan *Client),
		remove:     make(chan *Client),
		hub:        hub,
		isOpen:     true,
	}
}

func (r *Room) run() {
	for {
		select {
		// include a channel to handle temporary disconnects
		//
		// this should communicate with the hub to wait for the client to connect again, may also need to include a new field for Client struct to store a unique identifier that the client will have upon reconnecting. (uid in future increments with auth)
		//TODO

		case _ = <-r.remove:
			// determine which client has been received, if it is client_one that means this room should Close.
			//
			fmt.Println("=== removing client and closing room")
			//* right now this closes the room if either user disconnects/presses Home. This leaves the other player in a frozen state but when an iteration with game flow comes in, the process of removing the room will align with the game loop. Right now it's a little weird.
			r.hub.closeRoom <- r
		case client := <-r.place:
			//assign incoming client as client_one if available, otherwise client_two
			if r.client_one == nil {
				fmt.Println("=== a room received its first client")
				r.client_one = client

				responseObj := &ServerGameState[MatchmakingState]{Phase: Matchmaking, State: MatchmakingState{Status: FindingGame, Data: nil}}

				response := responseObj.JsonBlob()

				r.client_one.send <- response

			} else {
				fmt.Println("=== a room received its second client")
				r.client_two = client
				r.isOpen = false

				responseObj := &ServerGameState[MatchmakingState]{Phase: Matchmaking, State: MatchmakingState{Status: GameFound, Data: nil}}

				response, _ := json.Marshal(responseObj)

				r.client_one.send <- response
				r.client_two.send <- response
			}
		case action := <-r.process:

			//TODO
			//1. turn action into GameAction struct

			//2. perform logic on InGameState based on GameAction

			//3. send updated GameStateView to both clients
			jsonParsed, err := gabs.ParseJSON(action)
			if err != nil {
				fmt.Println(err)
			}

			value, _ := jsonParsed.Path("phase").Data().(string)

			fmt.Printf("parsed phase: %s", value)

			//determine what type of action (matchmaking, setup, tap key, guess word, continue, etc.)
			//TODO

			//perform game logic using r.game and associated method with action and update state accordingly
			//TODO

			//send the visual state of the game with only the required data for the user to use all in-game functionality
			//TODO

			//* actions are resent to both clients.
			// r.client_one.send <- action
			// r.client_two.send <- action
		}
	}
}
