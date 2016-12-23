/**
 * Created by LibraStudio on 2016/12/22.
 */
var Chat = function(socket) {
    this.socket = socket;
};
// クライアントに書き込んだメッセージ内容を返す.
Chat.prototype.sendMessage = function(message) {
    this.socket.emit('newChatMessage', {message: message});
}
