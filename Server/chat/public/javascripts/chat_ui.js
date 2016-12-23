/**
 * Created by LibraStudio on 2016/12/22.
 */

// チャットメッセージ書き込み.
function updateChatMessage(chatApp, name, message) {
    if (name == "山田 太郎") {
        var messageElement = $("<il><p class='sender_name me'>" + name + "</p><p class='right_balloon'>" + message + "</p><p class='clear_balloon'></p></il>");
        // クライアントに通知.
        chatApp.sendMessage(message);
    } else {
        var messageElement = $("<il><p class='sender_name'>" + name + "</p><p class='left_balloon'>" + message + "</p><p class='clear_balloon'></p></il>");
    }
    // チャットボードに書き込み.
    $('#messages').append(messageElement);
    $('#messages').scrollTop($('#messages').prop('scrollHeight'));
    $('#send-message').val('');
}
var socket = io.connect('http://ドメイン名.xip.io:3000');

$(document).ready(function () {
    var chatApp = new Chat(socket);
    // ルーム参加.
    socket.on('joinResult', function (result) {
        console.log("ルームへ入室")
        $('#room').text("接続しているルーム:  " + result.room);
    });

    // クライアントから来たメッセージ受信.
    socket.on('receiveMessage', function (data) {
        updateChatMessage(chatApp, data.name, data.message);
    });

    $("#send-message").focus();
    // 「送信」ボタンクリック.
    $('#send-button').click(function () {
        // フォームに入力したメッセージを取得.
        var message = $('#send-message').val();
        updateChatMessage(chatApp, "山田 太郎", message);
    });
});
