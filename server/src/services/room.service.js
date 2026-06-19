const rooms = new Map();

export const createRoom = (cameraId, streamerSocketId) => {
  rooms.set(cameraId, {
    cameraId,
    streamerSocketId,
    viewers: new Set(),
  });
};

export const getRoom = (cameraId) => {
  return rooms.get(cameraId);
};

export const removeRoom = (cameraId) => {
  rooms.delete(cameraId);
};

export const addViewer = (cameraId, viewerSocketId) => {
  const room = rooms.get(cameraId);

  if (!room) return false;

  room.viewers.add(viewerSocketId);

  return true;
};

export const removeViewer = (cameraId, viewerSocketId) => {
  const room = rooms.get(cameraId);

  if (!room) return;

  room.viewers.delete(viewerSocketId);
};

export const getRooms = () => {
  return Array.from(rooms.values());
};
