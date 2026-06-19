import dotenv from "dotenv";
dotenv.config();

import express from "express";
import http from "http";

import { initializeSocket } from "./config/socket.js";
import { getRooms } from "./services/room.service.js";

const app = express();

app.get("/", (_, res) => {
  res.json({
    success: true,
    message: "Portal Signaling Server Running",
  });
});

app.get("/health", (_, res) => {
  res.status(200).json({
    status: "ok",
  });
});

app.get("/rooms", (_, res) => {
  res.json(getRooms());
});

const server = http.createServer(app);

initializeSocket(server);

const PORT = process.env.PORT || 5000;

server.listen(PORT, () => {
  console.log(`Portal Signaling Server running on port ${PORT}`);
});
