package main

// / setup channel accepts states from client that will create the game's boards
// / play channel accepts states from client that will execute player turns and update game state

// / uses room.gameUpdate to send game states to clients
type Game struct {
	isDone bool
	room   *Room

	setup chan *ClientStateSetup
	play  chan *ClientStateInGame
}

// ! having room in parameter is unknown if it works yet. Still need to figure that out
func newGame(room *Room) *Game {
	return &Game{
		isDone: false,
		room:   room,
	}
}
