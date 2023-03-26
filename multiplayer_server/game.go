package main

import "fmt"

// / setup channel accepts states from client that will create the game's boards
// / play channel accepts states from client that will execute player turns and update game state

// / uses room.gameUpdate to send game states to clients
type Game struct {
	isDone          bool
	room            *Room
	playerOneBoard  GameBoard
	playerTwoBoard  GameBoard
	playerOneId     string
	playerTwoId     string
	playerOneActive bool
	playerTwoActive bool

	setup     chan *ClientStateSetup
	play      chan *ClientStateInGame
	matchmake chan *ClientStateMatchmaking
}

func (g *Game) run() {
	for {
		select {
		case clientStateMatchmaking := <-g.matchmake:
			// first state coming through is when user presses 'Ready' button
			if clientStateMatchmaking.ClientId == g.playerOneId {
				g.playerOneActive = true
			} else {
				g.playerTwoActive = true
			}

			// if both uers have pressed 'Ready' then setup needs to begin (so ServerStateSetup should be sent to room)
			if g.playerOneActive && g.playerTwoActive {
				serverStateMatchmaking := ServerStateMatchmaking{
					MatchmakingStep: "EndMatchmaking",
					isSendToBoth:    true,
				}
				g.room.matchmakingUpdate <- &serverStateMatchmaking
				// serverStateSetup := ServerStateSetup{
				// 	SetupStep: "Initial",
				// }
				// g.room.setupUpdate <- &serverStateSetup
			} else if g.playerOneActive && !g.playerTwoActive {
				// send AwaitingOpponent to playerOne
				serverStateMatchmaking := ServerStateMatchmaking{
					MatchmakingStep: "AwaitingOpponentReady",
					ClientId:        g.room.client_one.uid,
				}
				g.room.matchmakingUpdate <- &serverStateMatchmaking
			} else {
				serverStateMatchmaking := ServerStateMatchmaking{
					MatchmakingStep: "AwaitingOpponentReady",
					ClientId:        g.room.client_two.uid,
				}
				g.room.matchmakingUpdate <- &serverStateMatchmaking
			}
		case clientStateSetup := <-g.setup:
			fmt.Printf("Received setup state at step: %s from %s\n", clientStateSetup.SetupStep, clientStateSetup.ClientID)
			serverStateSetup := ServerStateSetup{
				SetupStep: "ServerSaysHi",
			}
			g.room.setupUpdate <- &serverStateSetup
		}
	}
}

type GameBoard struct {
}
