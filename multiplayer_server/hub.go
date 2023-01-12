package main

const (
	maxRooms = 1024
)

type Hub struct {
	rooms   RoomQueue
	clients map[*Client]bool

	register   chan *Client
	unregister chan *Client

	finishGame chan *Room
}

func newHub() *Hub {
	return &Hub{
		rooms:      *newRoomQueue(),
		register:   make(chan *Client),
		unregister: make(chan *Client),
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
		}
	}
}

// Holds rooms that are being played and rooms that are awaiting one more player.
//
// `availableRoomIdx` holds the spot in the queue where the next available room is. This allows the hub to quickly server the next available client with an available room, while being sure not to skip any rooms that are created/filled at the same time.
type RoomQueue struct {
	rooms            []*Room
	availableRoomIdx int
}

func newRoomQueue() *RoomQueue {
	return &RoomQueue{
		rooms:            make([]*Room, 0, maxRooms),
		availableRoomIdx: -1,
	}
}

func (rq *RoomQueue) addRoom(r *Room) {
	rq.rooms = append(rq.rooms, r)

	// if availableRoomIdx is -1, there are no available rooms, meaning the new room added at idx 0 will be the first available room in the hub.
	if rq.availableRoomIdx == -1 {
		rq.availableRoomIdx = 0
	}
}

func (rq *RoomQueue) getOpenRoom() *Room {
	if rq.availableRoomIdx == -1 {
		return nil
	}

	r := rq.rooms[rq.availableRoomIdx]
	rq.availableRoomIdx--

	//adjust availableRoomIdx so that it is pointing to the next available room in the queue
	for {
		if rq.rooms[rq.availableRoomIdx].isOpen || rq.availableRoomIdx < 0 {
			break
		}
		rq.availableRoomIdx--
	}

	return r
}
