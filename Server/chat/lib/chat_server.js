/**
 *
 * Created by LibraStudio on 2016/12/22.
 */

var socketio = require('socket.io');
var io;

exports.listen = function (server) {
    io = socketio.listen(server);
    io.sockets.on('connection', function (clientSocket) {
        console.log("WebSocket接続");

        // 接続したユーザーをroomに入れる.
        joinRoom(clientSocket, 'room');
        // チャットメッセージを書き込むと処理する.
        handleMessageBroadcasting(clientSocket);

        // クライアントから送られてくるチャットメッセージ受け取り.
        clientSocket.on("from_client", function (name, message) {
            console.log("クライアントから送られてきたname: %s", name);
            console.log("クライアントから送られてきたmessage: %s", message);
            io.sockets.emit('receiveMessage', {name: name, message: message});
        });
    });
};

function joinRoom(clientSocket, room) {
    // ユーザーをルームに参加させる.
    clientSocket.join(room);
    // ユーザーに新しいルームに入ったことを知らせる.
    clientSocket.emit('joinResult', {room: room});
}

function handleMessageBroadcasting(clientSocket) {
    clientSocket.on('newChatMessage', function (message) {
        console.log("チャットにサーバーから書き込み");
        // チャットに書き込んだメッセージをクライアントに通知.
        io.emit('from_server', message.message)
    });
}
