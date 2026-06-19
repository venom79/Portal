import {
  createRoom,
  getRoom,
  removeRoom,
  addViewer,
} from "../services/room.service.js";
import { SOCKET_EVENTS } from "../constants/socket-events.js";

export const signalingHandler = (io, socket) => {
  console.log(`Client Connected: ${socket.id}`);

  socket.onAny((event, ...args) => {
    console.log(event, args);
  });

  socket.on(SOCKET_EVENTS.REGISTER_CAMERA, ({ cameraId }) => {
    const existingRoom = getRoom(cameraId);

    if (existingRoom) {
      socket.emit(SOCKET_EVENTS.CAMERA_ALREADY_EXISTS);
      return;
    }

    createRoom(cameraId, socket.id);

    socket.cameraId = cameraId;
    socket.role = "streamer";

    socket.emit(SOCKET_EVENTS.CAMERA_REGISTERED, {
      cameraId,
    });

    console.log(`Camera Registered: ${cameraId}`);
  });

  socket.on(SOCKET_EVENTS.JOIN_CAMERA, ({ cameraId }) => {
    const room = getRoom(cameraId);

    if (!room) {
      socket.emit(SOCKET_EVENTS.CAMERA_NOT_FOUND);
      return;
    }

    addViewer(cameraId, socket.id);

    socket.cameraId = cameraId;
    socket.role = "viewer";

    io.to(room.streamerSocketId).emit(SOCKET_EVENTS.VIEWER_JOINED, {
      viewerId: socket.id,
    });

    socket.emit(SOCKET_EVENTS.JOINED_CAMERA, {
      cameraId,
    });
    console.log(`Viewer ${socket.id} joined camera ${cameraId}`);
  });

  socket.on(SOCKET_EVENTS.OFFER, ({ targetId, offer }) => {
    io.to(targetId).emit(SOCKET_EVENTS.OFFER, {
      senderId: socket.id,
      offer,
    });
  });

  socket.on(SOCKET_EVENTS.ANSWER, ({ targetId, answer }) => {
    io.to(targetId).emit(SOCKET_EVENTS.ANSWER, {
      senderId: socket.id,
      answer,
    });
  });

  socket.on(SOCKET_EVENTS.ICE_CANDIDATE, ({ targetId, candidate }) => {
    io.to(targetId).emit(SOCKET_EVENTS.ICE_CANDIDATE, {
      senderId: socket.id,
      candidate,
    });
  });

  socket.on(SOCKET_EVENTS.DISCONNECT, () => {
    console.log(`Disconnected: ${socket.id}`);

    if (socket.role === "streamer" && socket.cameraId) {
      const room = getRoom(socket.cameraId);

      if (room) {
        room.viewers.forEach((viewerId) => {
          io.to(viewerId).emit(SOCKET_EVENTS.STREAM_OFFLINE);
        });
      }

      removeRoom(socket.cameraId);
    }
  });

  socket.on("debug", (data) => {
    console.log(`[DEBUG] ${socket.id}:`, data.message);
  });
};
