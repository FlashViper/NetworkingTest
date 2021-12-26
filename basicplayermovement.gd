class_name PlayerMovement extends KinematicBody2D

signal updatePosition(position)

const MAX_SPEED = 600
const DEADZONE = 0.7

const ACCEL := 1000
const FRICTION_SPEED := 400
const FRICTION_REVERSE := 1200
const FRICTION_STOP := 500

var dashSpeed = 700
var velocity := Vector2()

puppet var puppetPos : Vector2
puppet var puppetVelocity : Vector2

var prevInputDir := Vector2(1,0)

func _ready() -> void:
	$Area2D.connect("body_entered", self, "onBodyEnter")
	if get_tree().network_peer: 
		$Label.text = name

func _process(delta: float) -> void:
	$PlayerVisual.updateAnim(velocity, prevInputDir)

func _physics_process(delta: float) -> void:
#	print(name, is_network_master())
	if not get_tree().network_peer or is_network_master():
		movement(delta)
		updatePuppet()
	else:
		doPuppet()
	
	velocity = move_and_slide(velocity)

func doPuppet() -> void:
	position = lerp(position, puppetPos, 0.8)
	velocity = puppetVelocity

func movement(delta: float) -> void:
	var inputDir := Input.get_vector("inputLeft", "inputRight", "inputUp", "inputDown").normalized()
	var inputDash := Input.is_action_just_pressed("inputDash")
	if not OS.is_window_focused():
		inputDir = Vector2()
		inputDash = false
	if inputDir.length_squared() > DEADZONE * DEADZONE:
		prevInputDir = inputDir
	
	
	if inputDash:
		if velocity.length_squared() < pow(MAX_SPEED + 75, 2):
			var maxAngle := 120
			var multiplier := clamp(abs(45 - deg2rad(velocity.angle_to(inputDir))), 0, maxAngle) / maxAngle
			velocity = prevInputDir * dashSpeed + velocity * (1 - multiplier)
	
	var acceleration := ACCEL
	if inputDir.length_squared() < DEADZONE * DEADZONE:
		acceleration = FRICTION_STOP
	elif velocity.length_squared() > MAX_SPEED * MAX_SPEED and velocity.normalized().dot(inputDir) > 0.25:
		acceleration = FRICTION_SPEED
	elif velocity.normalized().dot(inputDir) < 0:
		acceleration = FRICTION_REVERSE
	velocity = velocity.move_toward(MAX_SPEED * inputDir, acceleration * delta)

func updatePuppet() -> void:
	rset("puppetPos", position)
	rset("puppetVelocity", velocity)

func onBodyEnter(body: Node) -> void:
	var force := velocity.normalized() * max(500, velocity.length())
	print(force)
	body.rpc("addForce", velocity * 0.9)
#	velocity = -velocity * 0.5
#	print("OWCH")

remote func addForce(force:Vector2) -> void:
	velocity += force
