import { Server } from "socket.io";
import { signalingHandler } from "../handlers/signaling.handler.js";

export function initializeSocket(server) {
  const io = new Server(server, {
    cors: {
      origin: "*",
    },
  });

  io.on("connection", (socket) => {
    console.log("Client Connected:", socket.id);

    socket.on("disconnect", () => {
      console.log("Client Disconnected:", socket.id);
    });

    signalingHandler(io, socket);
  });

  return io;
}
