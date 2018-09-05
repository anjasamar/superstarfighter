# script bomb
extends Area2D

export var velocity = Vector2(18, 0)

var player_id

var Explosion = preload('res://actors/Explosion.tscn')
var width
var height
const CLEANUP_DISTANCE = 100

	
func _ready():
	width = get_viewport().size.x
	height = get_viewport().size.y
	
	# remove particle trail if not moving
	if position.x == 0 and position.y == 0:
		$Particles2D.queue_free()

func _physics_process(delta):
	position.x += velocity.x
	position.y += velocity.y
	
	# remove bomb if far outside the screen
	if position.x > width+CLEANUP_DISTANCE or position.x <= -CLEANUP_DISTANCE or position.y > height+CLEANUP_DISTANCE or position.y <= -CLEANUP_DISTANCE:
		queue_free()
	
func detonate():
	queue_free()
	var explosion = Explosion.instance()
	get_node('/root/Arena/Battlefield').add_child(explosion)
	explosion.player_id = player_id
	explosion.position = position

func _on_Bomb_area_entered(area):
	# bombs always explode when they touch objects with the Trigger component
	if area.has_node('TriggerComponent'):
		detonate()