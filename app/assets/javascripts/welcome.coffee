$ ->
	uri = 'http://localhost:3100/api/v1/'
	user = ''
	userName = ''
	client = ''
	user_id = ''
	chat_to = ''
	token = ''
	content_type = 'application/json'
	sign_in = ->
		$.ajax
			type: 'POST'
			url: uri + 'users/sign_in'
			contentType: 'application/json'
			dataType: 'json'
			data: JSON.stringify({ user: { email: "fagripa@rootstrap.com", password: "fede1234" } })
			success: (data, status, request) ->
				user = request.getResponseHeader('uid')
				user_id = data.user.id
				token = request.getResponseHeader('access-token')
				client = request.getResponseHeader('client')
				load_chats()
			error: ->
				console.log('error on login')
	sign_in()
	load_chats = ->
		$.ajax
			type: 'get'
			url: uri + 'chats/'
			headers: {
				'access-token': token,
				'uid': user,
				'client': client
			}
			contentType: content_type
			success: (data) ->
				jQuery.each data.chats, (i, chat) ->
					$('.chat-list-container').append("<li class='chat-item' id=" + chat.id + " >" + chat.name + '</li>')
			error: ->
				console.log('no chats')
				$('.chat-list').append('<h2> ERROR: NO CHATS </h2>')
	
	$(document).on 'click', '.chat-item', () ->
		chat = this.id
		$('.chat-item').css('background-color', 'white')
		$('.chat-item').removeClass('selected')
		$(this).css('background-color', 'azure')
		$(this).addClass('selected')
		chat_to = $($(this).text().split('_')).not([user]).get()[0]
		window.openChat(user_id)
		$.ajax
			type: 'GET'
			url: uri + 'chats/' + chat
			contentType: 'application/json'
			headers: {
				'access-token': token,
				'uid': user,
				'client': client 
			}
			data: { page: 1 }
			success: (data) ->
				$('.chat-history').empty()
				jQuery.each data.messages, (i, message) ->
					$('.chat-history').append('<div><p>' + message.content + '</p></div>')
			error: ->
				console.log('Error retrieving chat messages')
				$('.chat-history').empty()
				$('.chat-history').append('<h2> MESSAGES COULDT BE RETRIEVED </h2>')

	$('#send-message').on 'keypress', (e) ->
		code = e.which
		if (code == 13)
			input = $(this).val()
			App.chat.send_message(input, chat_to)
			$(this).val('')