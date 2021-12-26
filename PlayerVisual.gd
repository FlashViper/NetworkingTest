extends Node2D

onready var tween := $Tween
var noise : OpenSimplexNoise
var elapsed : float
var maxSpeed : float
var prevVelocity := Vector2(0,1)

func _ready() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	maxSpeed = 250
#	maxSpeed = PlayerMovement.MAX_SPEED

func updateAnim(velocity: Vector2, inputDir : Vector2) -> void:
	if velocity.length_squared() > maxSpeed * maxSpeed:
		var amount = inverse_lerp(maxSpeed, maxSpeed + 500, velocity.length())
		var noiseX = noise.get_noise_2d(elapsed, 0)
		var noiseY = noise.get_noise_2d(elapsed, 256)
		$Sprite.scale = Vector2.ONE + Vector2(
			lerp(0, 0.3, amount) * noiseX,
			lerp(0, 0.3, amount) * noiseY)
	if velocity.length_squared() > 0.065:
		prevVelocity = velocity
	$Sprite.rotation = lerp_angle($Sprite.rotation, prevVelocity.angle() + PI / 2, 0.1)
#	$Sprite.rotation = lerp_angle($Sprite.rotation, inputDir.angle() + PI / 2, 0.1)
