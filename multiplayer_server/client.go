package main

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
)

const (
	// Time allowed to write a message to the peer.
	writeWait = 10 * time.Second

	// Time allowed to read the next pong message from the peer.
	pongWait = 60 * time.Second

	// Send pings to peer with this period. Must be less than pongWait.
	pingPeriod = (pongWait * 9) / 10

	// Maximum message size allowed from peer.
	maxMessageSize = 512
)

var (
	newline = []byte{'\n'}
	space   = []byte{' '}
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

// Handles all reads/writes to a websocket connection and communicates between the connection and the hub and between the connection and the room the game is being played in.
type Client struct {
	send chan []byte //*byte array, should be a game state encoded into a string

	hub *Hub

	room *Room

	conn *websocket.Conn
}

// readPump pumps messages from the websocket connection to the hub.
//
// The application runs readPump in a per-connection goroutine. The application
// ensures that there is at most one reader on a connection by executing all
// reads from this goroutine.
func (c *Client) readPump() {

	// Wait to unregister and close connection until the read message loop is broken out of
	defer func() {
		c.hub.unregister <- c
		c.conn.Close()
	}()

	c.conn.SetReadLimit(maxMessageSize)
	c.conn.SetReadDeadline(time.Now().Add(pongWait))
	c.conn.SetPongHandler(func(string) error {
		c.conn.SetReadDeadline(time.Now().Add(pongWait))
		return nil
	})

	// Continuously read from websocket connection
	for {

		// read from websocket connection, save message into action to be processed by the room
		// the current client is connected to
		_, action, err := c.conn.ReadMessage()

		// remove client from room on websocket read error
		if err != nil {
			c.room.remove <- c
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("error: %v", err)
			}
			break
		}

		// clean up action string
		action = bytes.TrimSpace(bytes.Replace(action, newline, space, -1))

		// send to room via process channel
		c.room.process <- action
	}
}

// writePump pumps messages from the hub to the websocket connection.
//
// A goroutine running writePump is started for each connection. The
// application ensures that there is at most one writer to a connection by
// executing all writes from this goroutine.
func (c *Client) writePump() {

	// use ticker to send ping messages after duration of pingPeriod is complete
	ticker := time.NewTicker(pingPeriod)

	// wait until writePump() will return before stopping ticker and closing connection
	defer func() {
		ticker.Stop()
		c.conn.Close()
	}()
	for {
		select {
		// receieve message from client's send channel to be written to websocket
		case message, ok := <-c.send:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if !ok {
				// The hub closed the channel.
				c.conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}

			// send message to websocket
			w, err := c.conn.NextWriter(websocket.TextMessage)
			if err != nil {
				return
			}
			w.Write(message)

			//* maybe remove. this was from the chat example
			// Add queued chat messages to the current websocket message.
			// n := len(c.send)
			// for i := 0; i < n; i++ {
			// 	w.Write(newline)
			// 	w.Write(<-c.send)
			// }

			if err := w.Close(); err != nil {
				return
			}

		// pingPeriod duration complete, write ping message to websocket
		case <-ticker.C:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := c.conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}

// serveWs() serves a websocket to the client and assigns the client to a room
func serveWs(hub *Hub, w http.ResponseWriter, r *http.Request) {
	fmt.Printf("=== User has connected: %v\n", time.Now())
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}

	// if a room is available assign the client to it otherwise create a new room
	room := hub.rooms.getOpenRoom()
	if room == nil {
		room = newRoom(hub)
		go room.run()
		hub.rooms.addRoom(room)
	}

	// when creating a Client, also need to include the room stored above.
	client := &Client{hub: hub,
		room: room,
		conn: conn,
		send: make(chan []byte, 256),
	}

	//Client is also sent to the Room stored above via the client.room.place channel, which accepts *Client
	client.hub.register <- client
	client.room.place <- client

	// Allow collection of memory referenced by the caller by doing all work in
	// new goroutines.
	go client.writePump()
	go client.readPump()
}
