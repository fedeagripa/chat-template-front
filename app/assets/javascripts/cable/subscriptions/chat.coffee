window.openChat = (user_id) ->
  App.chat = App.cable.subscriptions.create {channel:'ChatChannel', chat_id: $('.chat-item.selected').attr('id'),
  user: user_id}, 
    received: (data) ->
      @appendLine(data)

    send_message: (data, chat_id) ->
      @perform 'send_message', message: data, chat_id: chat_id

    appendLine: (data) ->
      html = @createLine(data)
      $('.chat-history').append(html)
   
    createLine: (data) ->
      """<div><p>
          <span class="speaker">#{data.user}</span>
          <span class="body">#{data.content}</span>
          <span class="markdown">#{data.date}</span>
      </p></div>"""
