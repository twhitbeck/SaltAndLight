// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.

socket.connect()

// Now that you are connected, you can join channels with a topic:
//let channel = socket.channel("topic:subtopic", {})
//channel.join()
//  .receive("ok", resp => { console.log("Joined successfully", resp) })
//  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
