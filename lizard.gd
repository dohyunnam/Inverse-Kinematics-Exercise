extends Line2D

var segment_lengths = []

@export var speed: float = 300.0  # Speed of movement towards the target
@export var wave_curve: Curve

@onready var path: Line2D = $path
@onready var checkup = path.points

var target_position = get_point_position(0)
var current_position = get_point_position(0)

var temp_current_position = current_position
var distance = 1.0
var t = 0.0

@export var max_limb_length : int = 100
@export var limb_indexes : Array[int] = [4, 6]
@export var armspan: int = 10
@export var limb_length: int = 40

var limb_list : Dictionary

func create_limb(body_index: int, armspan: int, limb_length: int) -> Line2D:
	var line = Line2D.new()
	line.default_color = Color.WHITE
	line.width = 10
	var position = get_point_position(body_index)
	line.name = "Line2D_" + str(body_index)
	line.add_point(position + Vector2(0, limb_length))
	line.add_point(position + Vector2(0, armspan))
	line.add_point(position + Vector2(0, -armspan))
	line.add_point(position + Vector2(0, -limb_length))
	
	add_child(line)
	
	return line

func _ready() -> void:
	segment_lengths.clear()
	for i in limb_indexes:
		
		var node: Line2D = create_limb(i, armspan, limb_length)
		limb_list[i] = [node, [node.get_point_position(0), node.get_point_position(3)]]
	
	for point_index in range(1, get_point_count()):
		var current_point_pos = get_point_position(point_index)
		var prev_point_pos = get_point_position(point_index - 1)
		var length = current_point_pos.distance_to(prev_point_pos)
		segment_lengths.append(length)
		
	target_position = path.get_point_position(0)
	temp_current_position = current_position
	distance = current_position.distance_to(target_position)

var iter = 1

func _physics_process(delta: float) -> void:
	
	if current_position.distance_to(path.get_point_position((iter - 1) % path.get_point_count())) < 10 or checkup != path.points:
		if checkup != path.points:
			checkup = path.points
			iter = 1
		
		target_position = path.get_point_position(iter % path.get_point_count())
		
		temp_current_position = current_position
		distance = current_position.distance_to(target_position)
		iter += 1
		t = 0.0
	
	if current_position != target_position:
		current_position = get_point_position(0)
		t += delta
		
		set_point_position(0, temp_current_position.lerp(target_position,  min(1, t * speed / distance)))
		for point_index in range(1, get_point_count()):
			var current_point_pos = get_point_position(point_index)
			var next_point_pos = get_point_position(point_index - 1)
			
			var new_point_pos = next_point_pos - ((next_point_pos - current_point_pos).normalized() * segment_lengths[point_index - 1])
			
			set_point_position(point_index, new_point_pos)
		
		
		for i in limb_list:
			limb_list[i][1][0] = calculate_third_point(get_point_position(i), get_point_position(i-1), -50, 60)
			limb_list[i][1][1] = calculate_third_point(get_point_position(i), get_point_position(i-1), 230, 60)
			
			limb_list[i][0].set_point_position(2, calculate_third_point(get_point_position(i), get_point_position(i-1), 180, 10))
			limb_list[i][0].set_point_position(1, calculate_third_point(get_point_position(i), get_point_position(i-1), 0, 10))
			
			if limb_list[i][0].get_point_position(0).distance_to(get_point_position(i)) > 60:
				limb_list[i][0].set_point_position(0, limb_list[i][1][0])
			if limb_list[i][0].get_point_position(3).distance_to(get_point_position(i)) > 60:
				limb_list[i][0].set_point_position(3, limb_list[i][1][1])

func calculate_third_point(A: Vector2, B: Vector2, angle: float, length: float) -> Vector2:
	var direction = (B - A).normalized()
	var angle_rad = angle * (PI / 180)
	var perpendicular = Vector2(-direction.y, direction.x).rotated(angle_rad)
	var C = A + perpendicular * length
	return C

func _draw():
	#for point_index in range(get_point_count()):
		#var point_position = get_point_position(point_index)
		#draw_circle(point_position, 5, Color.ORANGE_RED)
		#
	for i in limb_list:
		#print(limb_list[i][0])
		draw_circle(limb_list[i][0].get_point_position(0), 5, Color.WHITE)
		#draw_circle(limb_list[i][0].get_point_position(1), 10, Color.ORANGE_RED)
		#draw_circle(limb_list[i][0].get_point_position(2), 10, Color.ORANGE_RED)
		draw_circle(limb_list[i][0].get_point_position(3), 5, Color.WHITE)
