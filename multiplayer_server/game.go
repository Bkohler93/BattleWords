package main

type Game struct {
	isDone bool
}

func newGame() *Game {
	return &Game{
		isDone: false,
	}
}
