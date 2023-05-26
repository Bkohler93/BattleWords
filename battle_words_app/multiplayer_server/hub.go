package main

import "fmt"

const (
	maxRooms = 1024
)

type Hub struct {
	rooms   RoomQueue
	clients map[*Client]bool

	register   chan *Client
	unregister chan *Client

	closeRoom chan *Room
}

func newHub() *Hub {
	return &Hub{
		rooms:      *newRoomQueue(),
		register:   make(chan *Client),
		unregister: make(chan *Client),
		closeRoom:  make(chan *Room),
		clients:    make(map[*Client]bool),
	}
}

func (h *Hub) run() {
	for {
		select {
		case client := <-h.register:
			h.clients[client] = true
		case client := <-h.unregister:
			//only delete if value with key client is true
			if _, ok := h.clients[client]; ok {
				delete(h.clients, client)
				close(client.send)
			}
		case room := <-h.closeRoom:
			h.rooms.remove(room)
			fmt.Printf("=== room removed, current room count: %v\n", len(h.rooms.queue))
		}
	}
}

// Holds rooms that are being played and rooms that are awaiting one more player.
//
// `availableRoomIdx` holds the spot in the queue where the next available room is. This allows the hub to quickly server the next available client with an available room, while being sure not to skip any rooms that are created/filled at the same time.
type RoomQueue struct {
	queue            []*Room
	availableRoomIdx int
}

func newRoomQueue() *RoomQueue {
	return &RoomQueue{
		queue:            make([]*Room, 0, maxRooms),
		availableRoomIdx: -1,
	}
}

func (rq *RoomQueue) addRoom(r *Room) {
	rq.queue = append(rq.queue, r)

	// if availableRoomIdx is -1, there are no available rooms, meaning the new room added at idx 0 will be the first available room in the hub.
	if rq.availableRoomIdx == -1 {
		rq.availableRoomIdx = 0
	}
}

func (rq *RoomQueue) getOpenRoom() *Room {
	if rq.availableRoomIdx == -1 {
		return nil
	}
	r := rq.queue[rq.availableRoomIdx]
	rq.availableRoomIdx--
	//adjust availableRoomIdx so that it is pointing to the next available room in the queue
	for {
		if rq.availableRoomIdx < 0 || rq.queue[rq.availableRoomIdx].isOpen {
			break
		}
		rq.availableRoomIdx--
	}

	return r
}

func (rq *RoomQueue) remove(room *Room) {
	index := -1
	for idx, val := range rq.queue {
		if val == room {
			index = idx
			break
		}
	}
	if len(rq.queue) < 2 {
		rq.queue = make([]*Room, 0, maxRooms)
		rq.availableRoomIdx = -1
	} else {
		rq.queue = append(rq.queue[1:index], rq.queue[index+1:]...)
		if index < rq.availableRoomIdx { //removing room at index causes availableRoomIdx to drop by one to accomodate for the removal of the room
			rq.availableRoomIdx--
		}
	}
}
