# Portal

A lightweight self-hosted CCTV and remote monitoring system built with Flutter, WebRTC, Socket.IO, and Node.js.

Portal turns an old Android phone into a live camera that can be accessed remotely from another device with low-latency peer-to-peer streaming.

## Features

### Current (v0.1)

* Live camera streaming using WebRTC
* Real-time signaling with Socket.IO
* Camera registration system
* Viewer connection system
* ICE candidate exchange
* Local network streaming
* Android support
* Multi-device testing support

### Planned

* Multiple camera support
* Camera management dashboard
* Remote access through Cloudflare Tunnel
* Stream recording
* Motion detection
* Push notifications
* Authentication and access control
* Camera groups and locations
* Stream quality controls
* 24/7 monitoring mode

---

## Architecture

```text
Camera Phone
     │
     │ WebRTC
     ▼
Viewer Device

        ▲
        │
        │ Socket.IO Signaling
        │
        ▼

   Node.js Server
```

The signaling server is responsible for:

* Camera registration
* Viewer discovery
* Offer/Answer exchange
* ICE candidate exchange

Actual video traffic is streamed directly between devices using WebRTC.

---

## Tech Stack

### Mobile App

* Flutter
* flutter_webrtc
* socket_io_client

### Backend

* Node.js
* Express
* Socket.IO

### Networking

* WebRTC
* STUN Servers
* Socket.IO Signaling

---

## Project Structure

```text
portal/
│
├── app/
│   ├── controllers/
│   ├── screens/
│   ├── services/
│   └── main.dart
│
├── server/
│   ├── controllers/
│   ├── services/
│   ├── routes/
│   └── server.js
│
└── README.md
```

---

## Development Status

Portal is currently in active development.

The initial prototype successfully establishes peer-to-peer video streaming between devices using WebRTC and Socket.IO signaling.

Upcoming releases will focus on:

* Improved UI/UX
* Camera management
* Reliability improvements
* Self-hosted deployment
* Remote access support

---

## Why This Project?

Many old Android phones still have working cameras but end up unused.

Portal aims to repurpose these devices into low-cost security cameras and remote monitoring systems that can be self-hosted without relying on expensive cloud subscriptions.

---

## Author

Aditya Gaonkar

Built as a learning project exploring:

* Flutter
* WebRTC
* Real-time communication
* Self-hosting
* Mobile networking
* Peer-to-peer systems
