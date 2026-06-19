import { Server } from "socket.io";
import { signalingHandler } from "../handlers/signaling.handler.js";

export function initializeSocket(server) {
  const io = new Server(server, {
    cors: {
      origin: "*",
    },
  });

  io.on("connection", (socket) => {
    signalingHandler(io, socket);
  });

  return io;
}
