package main

import (
	"encoding/json"
	"fmt"
)

type Room struct {
	client_one *Client
	client_two *Client
	game       *Game

	process chan []byte //data received from clients
	place   chan *Client
	remove  chan *Client

	//channels to receive updates from Game to be sent to clients
	gameUpdate        chan *ServerStateInGame //Game uses this channel to send states for clients to view current state of game
	matchmakingUpdate chan *ServerStateMatchmaking
	setupUpdate       chan *ServerStateSetup

	//TODO FIGURE OUT HOW TO ASSOCIATE ROOM WITH A GAME (look over how hub/client/room all connect to each other)
	// createGame chan *Game

	hub *Hub

	isOpen bool //* guessing that this will be needed, may not be.
}

func newRoom(hub *Hub) *Room {
	return &Room{
		client_one: nil,
		client_two: nil,
		// game:       newGame(),
		process: make(chan []byte),
		place:   make(chan *Client),
		remove:  make(chan *Client),

		//channels to receive updates from Game to be sent from server to clients
		gameUpdate:        make(chan *ServerStateInGame),
		matchmakingUpdate: make(chan *ServerStateMatchmaking),
		setupUpdate:       make(chan *ServerStateSetup),

		hub:    hub,
		isOpen: true,
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

			if r.client_one == nil {
				fmt.Println("=== a room received its first client")
				r.client_one = client

				response := &ServerStateMatchmaking{MatchmakingStep: "FindingGame"}
				responseByte, err := json.Marshal(response)
				if err != nil {
					panic(err)
				}

				r.client_one.send <- responseByte

			} else {
				fmt.Println("=== a room received its second client")
				r.client_two = client
				r.isOpen = false

				response := &ServerStateMatchmaking{MatchmakingStep: "GameFound"}
				responseByte, err := json.Marshal(response)

				if err != nil {
					panic(err)
				}

				//Create game here since both players have joined
				r.game = &Game{
					room:      r,
					isDone:    false,
					setup:     make(chan *ClientStateSetup),
					play:      make(chan *ClientStateInGame),
					matchmake: make(chan *ClientStateMatchmaking),

					//! change uid's to player chosen names eventually
					playerOneId: r.client_one.uid,
					playerTwoId: r.client_two.uid,
				}
				go r.game.run()
				// fmt.Println("Send response to clients")

				r.client_one.send <- responseByte
				r.client_two.send <- responseByte

			}

		case action := <-r.process:
			var clientStateMatchmaking ClientStateMatchmaking
			var clientStateSetup ClientStateSetup
			var clientStateInGame ClientStateInGame

			err := json.Unmarshal(action, &clientStateMatchmaking)
			if err != nil {
				err = json.Unmarshal(action, &clientStateSetup)
				if err != nil {
					err = json.Unmarshal(action, &clientStateInGame)

					if err != nil {
						// this should never happen
						panic(err)
					}
					r.game.play <- &clientStateInGame
				} else {
					r.game.setup <- &clientStateSetup
				}
			} else {
				fmt.Printf("Matchmaking state received from client %s \t step %s\n", clientStateMatchmaking.ClientId, clientStateMatchmaking.MatchmakingStep)
				r.game.matchmake <- &clientStateMatchmaking
			}
		case serverMatchmakingState := <-r.matchmakingUpdate:
			if serverMatchmakingState.isSendToBoth {
				responseBye, err := json.Marshal(serverMatchmakingState)
				if err != nil {
					panic(err)
				}
				r.client_one.send <- responseBye
				r.client_two.send <- responseBye
			}
			if serverMatchmakingState.ClientId == r.client_one.uid {
				responseByte, err := json.Marshal(serverMatchmakingState)
				if err != nil {
					panic(err)
				}
				r.client_one.send <- responseByte
			}
			if serverMatchmakingState.ClientId == r.client_two.uid {
				responseByte, err := json.Marshal(serverMatchmakingState)
				if err != nil {
					panic(err)
				}
				r.client_two.send <- responseByte
			}

		case serverSetupState := <-r.setupUpdate:
			responseByte, err := json.Marshal(serverSetupState)
			if err != nil {
				panic(err)
			}
			r.client_one.send <- responseByte
			r.client_two.send <- responseByte

		case serverGameState := <-r.gameUpdate:
			fmt.Println("Sending new game state to clients")
			fmt.Println(serverGameState)
		}
	}
}
