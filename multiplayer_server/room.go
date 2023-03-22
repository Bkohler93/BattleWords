package main

import (
	"encoding/json"
	"fmt"
)

type Room struct {
	client_one *Client
	client_two *Client
	game       *Game

	process    chan []byte //data received from clients
	place      chan *Client
	remove     chan *Client
	gameUpdate chan *ClientStateInGame //Game uses this channel to send states for clients to view current state of game

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
		hub:     hub,
		isOpen:  true,
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
				} else {
					//! at this point r.game has not yet been initialize. WHERE TO INITIALIZE THIS? LOOK AT HOW hub/client/room all connect to each other.
					// r.game.play <- &clientStateInGame
				}
			} else {
				//! at this point r.game has not yet been initialized. WHERE TO INITIALIZE THIS? LOOK AT HOW hub/client/room all connect to each other.
				// r.game.matchmaking <- &clientStateMatchmaking
			}
			fmt.Println(clientStateMatchmaking.MatchmakingStep)
			fmt.Println(clientStateMatchmaking.ClientId)

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
