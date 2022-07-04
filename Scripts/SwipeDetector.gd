extends Node

signal swiped(direction)
signal swipedForward()
signal swipedLeft()
signal swipedRight()
signal swipedBack()
signal swipeCanceled(startPosition)

export(float, 1.0, 2.0) var MAX_DIAGONAL_SLOPE = 2
export(float, 0.0, 500) var MAX_DISTANCE = 70

onready var timer = $Timer
var swipeStartPos = Vector2()

var useSwipe = false

func _ready():
	if not self.get_parent().name.begins_with("Level"):
		useSwipe = true

func _input(event):
	if not event is InputEventScreenTouch or useSwipe == false:
		return
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)

func _start_detection(position):
	swipeStartPos = position
	timer.start()
	
func _end_detection(position):
	timer.stop()
	var direction = (position - swipeStartPos).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	if abs(direction.x) > abs(direction.y) and position.distance_to(swipeStartPos) >= MAX_DISTANCE:
		if(-sign(direction.x) > 0):
			emit_signal('swipedLeft')
		elif(-sign(direction.x) < 0):
			emit_signal('swipedRight')
		print(Vector2(-sign(direction.x), 0.0))
		#emit_signal('swiped', Vector2(-sign(direction.x), 0.0))
	elif position.distance_to(swipeStartPos) >= MAX_DISTANCE:
		if(-sign(direction.y) > 0):
			emit_signal('swipedForward')
		elif(-sign(direction.y) < 0):
			emit_signal("swipedBack")
		#emit_signal('swiped', Vector2(0.0, -sign(direction.y)))
		print( Vector2(0.0, -sign(direction.y)))
func _on_Timer_timeout():
	emit_signal('swipeCanceled', swipeStartPos)


func _on_sterowanie_pressed():
	if($"/root/Settings".loadSetting("options", "movement") == "swipe"):
		useSwipe = true
	else:
		useSwipe = false
