package main

type Room struct {
	client_one *Client
	client_two *Client
	game       *Game

	process chan []byte // receive from clients to process a GameAction made by client
	place   chan *Client

	hub *Hub

	isOpen bool //* guessing that this will be needed, may not be.
}

func (r *Room) run() {
	for {
		select {
		case client := <-r.place:
			//assign incoming client as client_one if available, otherwise client_two
			if r.client_one == nil {
				r.client_one = client
			} else {
				r.client_two = client
				r.isOpen = false
			}
		case action := <-r.process:
			//determine what type of action (tap key, guess word, continue, etc.)
			//TODO

			//perform game logic using r.game and associated method with action and update state accordingly
			//TODO

			//send the visual state of the game with only the required data for the user to use all in-game functionality
			//TODO

			//* actions are resent to both clients.
			r.client_one.send <- action
			r.client_two.send <- action
		}
	}
}
