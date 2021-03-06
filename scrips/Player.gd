extends Area2D

signal hit
export var consumed = 0
export var speed = 190
export var bonus_speed = 1
var isDashing = false
export var isAlive = true
var direction = Vector2()

func _ready():
	$CollisionShape2D.disabled = false

func _process(delta):
	look_at(get_viewport().get_mouse_position())
	follow(delta)
	readInput()

func readInput():
	if Input.is_action_pressed("ui_accept"):
		dash()

func follow(delta):
	direction = (get_viewport().get_mouse_position() - global_position)
	direction = direction.normalized()
	rotation = direction.angle()
	if position.distance_to(get_viewport().get_mouse_position()) > 20:
		position += speed * delta * direction * bonus_speed

func dash():
	if !isDashing:
		change_dashing()
		bonus_speed = 3
		yield(get_tree().create_timer(0.4), "timeout")
		bonus_speed = 1
		cooldown()

func cooldown():
	yield(get_tree().create_timer(2.0), "timeout")
	change_dashing()

func change_dashing():
	isDashing = !isDashing

func _on_Player_body_entered(body):
	body.consume()
	consumed += 1

func _on_Player_area_entered(_area):
	get_parent().player_die()

func die():
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	isAlive = false

func revive():
	isAlive = true
	position = Vector2(500, 300)
	consumed = 0
	show()
	$CollisionShape2D.set_deferred("disabled", false)
