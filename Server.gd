#Created by Finn Pickart
#https://finn378.itch.io/

extends Node

const MAX_PLAYERS = 16
const PORT = 31400

func _ready():
	# Connect the signals to functions
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	
	create_server() # Create the server

func create_server():
	# Creating the server
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT,MAX_PLAYERS)
	get_tree().network_peer = peer
	
	print("Server created")

func _player_connected(id):
	print("Client connected: " + str(id))

func _player_disconnected(id):
	print("Client disconnected: " + str(id))

remote func broadcast_audio(d,data,format,mix_rate,stereo,bsize):
	# Send the audio to all clients
	var i = get_tree().get_rpc_sender_id() # Get the rpc sender id
	
	if d == i: # Check if the given ip is equal to the rpc_sender_id (Safety reasons)
		rpc("play_voip",data,format,mix_rate,stereo,bsize) # Send the audio to all connected clients
		# If you want to send the audio to specific clients use rpc_id(id,[...])
	else:
		printerr("Broadcast Error 1")
