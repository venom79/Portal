# Portal

Portal is a lightweight self-hosted CCTV and remote monitoring system built with Flutter, WebRTC, Socket.IO, and Node.js.

It allows you to turn an Android device into a live camera and securely stream video to another device using peer-to-peer WebRTC connections.

If you already have a self-hosted server, VPS, home server, Raspberry Pi, old computer, or any machine capable of running Node.js, you can use Portal as your signaling server and create your own private camera system.

---

# What is Portal?

Portal is designed for people who want a simple alternative to cloud-based IP camera services.

Instead of sending your video through third-party providers, Portal uses:

* WebRTC for peer-to-peer video streaming
* Socket.IO for signaling
* A self-hosted Node.js server for device discovery and connection management

The actual video stream is sent directly between devices whenever possible.

---

# Why was Portal created?

Many old Android phones still have perfectly working cameras but end up sitting unused in drawers.

Portal aims to repurpose those devices into:

* Security cameras
* Pet cameras
* Baby monitors
* Room monitoring systems
* Remote observation cameras

without requiring expensive subscriptions or proprietary hardware.

---

# How does it work?

Portal uses three components:

```text
Android Camera Device
        │
        │ WebRTC Video Stream
        ▼
Viewer Device

        ▲
        │
        │ Socket.IO Signaling
        │
        ▼

Self-Hosted Node.js Server
```

### Camera Device

The camera device:

* Captures video
* Registers itself with the signaling server
* Creates WebRTC offers
* Streams video

### Viewer Device

The viewer device:

* Connects to the signaling server
* Finds a camera
* Receives WebRTC offers
* Displays the live stream

### Signaling Server

The signaling server:

* Registers cameras
* Connects viewers to cameras
* Exchanges SDP offers and answers
* Exchanges ICE candidates

The server never processes video data.

---

# Features

## Current Features

* Live video streaming using WebRTC
* Camera registration system
* Viewer connection system
* Socket.IO signaling
* ICE candidate exchange
* Local network streaming
* Android support
* Self-hosted signaling server
* Configurable server URL
* Multi-device testing support

## Planned Features

* Multiple camera support
* Camera management dashboard
* Stream recording
* Motion detection
* Push notifications
* Authentication and access control
* Camera groups and locations
* Stream quality controls
* Cloudflare Tunnel support
* Internet-accessible cameras
* 24/7 monitoring mode

---

# Tech Stack

## Mobile Application

* Flutter
* flutter_webrtc
* socket_io_client
* SharedPreferences

## Backend

* Node.js
* Express
* Socket.IO

## Networking

* WebRTC
* STUN Servers
* Socket.IO Signaling

---

# Project Structure

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
│   ├── handlers/
│   ├── routes/
│   ├── socket/
│   └── server.js
│
└── README.md
```

---

# Setup Guide

## 1. Clone the Repository

```bash
git clone https://github.com/yourusername/Portal.git
cd Portal
```

---

## 2. Setup the Signaling Server

Navigate to the server directory:

```bash
cd server
```

Install dependencies:

```bash
npm install
```

Create a `.env` file:

```env
PORT=5000
```

Start the server:

```bash
npm start
```

or

```bash
node server.js
```

You should see:

```text
Portal Signaling Server running on port 5000
```

---

## 3. Download and Install the Android App

Download the latest APK from the project's Releases page:

```text
https://github.com/venom79/Portal/releases/latest
```

Install the APK on:

* Camera device
* Viewer device

You may need to allow installation from unknown sources depending on your Android version.

---

## 4. Configure the Server Address

Open Portal.

Enter your server URL:

```text
http://YOUR_SERVER_IP:5000
```

Example:

```text
http://192.168.1.100:5000
```

Press:

```text
Save Server URL
```

---

## 5. Start Streaming

### Camera Device

* Open Portal
* Select Camera Mode
* Register the camera

### Viewer Device

* Open Portal
* Select Viewer Mode
* Enter the Camera ID
* Connect

The live stream should appear automatically.

---

# Development Status

Portal is currently in active development.

The project successfully establishes peer-to-peer video streaming between Android devices using WebRTC and a self-hosted signaling server.

Current development focuses on:

* Improved UI/UX
* Reliability improvements
* Internet-accessible deployments
* Multi-camera support
* Monitoring features

---

# Author

Aditya Gaonkar

Built as a learning project exploring:

* Flutter
* WebRTC
* Real-time communication
* Self-hosting
* Mobile networking
* Peer-to-peer systems
