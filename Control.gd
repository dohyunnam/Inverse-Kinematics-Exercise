extends Control

@onready var parent: Line2D = get_parent()
@onready var path: Line2D = parent.get_node("path")
# Variables to track the game state
var is_game_running = true

var is_drawing = false

func _ready():
	# Connect button signals
	$StartAndPause.connect("pressed", _on_button_pressed)
	$StartAndPause.text = "pause"
	$Reset.connect("pressed", _on_ResetButton_pressed)
	$Reset.text = "reset"
	$draw.connect("pressed", _on_DrawButton_pressed)
	$draw.text = "draw"
	$clear.connect("pressed", _on_ClearButton_pressed)
	$clear.text = "clear"
	
func _on_button_pressed():
	if path.points.size() >= 3 and not is_drawing:
		if not is_game_running:
			is_game_running = true
			print("Game Started")
			$StartAndPause.text = "start"
			get_tree().paused = false
		else:
			is_game_running = false
			print("Game Paused")
			$StartAndPause.text = "pause"
			get_tree().paused = true
	
func _on_ResetButton_pressed():
	var points = [
		Vector2(61, 250), Vector2(21, 240), Vector2(-6, 212), Vector2(-17, 179), Vector2(-15, 162),
		Vector2(-2, 148), Vector2(59, 147), Vector2(90, 158), Vector2(124, 178), Vector2(146, 180),
		Vector2(165, 171), Vector2(181, 158), Vector2(194, 135), Vector2(204, 111), Vector2(210, 95),
		Vector2(240, 78), Vector2(266, 70), Vector2(301, 80), Vector2(328, 110), Vector2(340, 136),
		Vector2(356, 151), Vector2(399, 154), Vector2(432, 143), Vector2(457, 126), Vector2(479, 111),
		Vector2(500, 99), Vector2(523, 98), Vector2(536, 112), Vector2(548, 151), Vector2(544, 191),
		Vector2(533, 212), Vector2(532, 239), Vector2(567, 252), Vector2(592, 251), Vector2(615, 236),
		Vector2(637, 230), Vector2(663, 244), Vector2(679, 282), Vector2(675, 313), Vector2(660, 346),
		Vector2(649, 390), Vector2(652, 431), Vector2(670, 473), Vector2(706, 475), Vector2(726, 469),
		Vector2(748, 470), Vector2(764, 489), Vector2(774, 510), Vector2(799, 537), Vector2(838, 554),
		Vector2(895, 563), Vector2(940, 558), Vector2(966, 534), Vector2(979, 490), Vector2(958, 466),
		Vector2(939, 435), Vector2(942, 413), Vector2(963, 390), Vector2(993, 349), Vector2(998, 306),
		Vector2(991, 263), Vector2(970, 242), Vector2(946, 234), Vector2(907, 232), Vector2(890, 235),
		Vector2(871, 244), Vector2(855, 263), Vector2(843, 279), Vector2(822, 285), Vector2(776, 290),
		Vector2(758, 263), Vector2(743, 228), Vector2(718, 200), Vector2(671, 199), Vector2(625, 232),
		Vector2(605, 274), Vector2(589, 321), Vector2(584, 362), Vector2(561, 410), Vector2(543, 418),
		Vector2(501, 402), Vector2(457, 367), Vector2(416, 353), Vector2(388, 374), Vector2(376, 409),
		Vector2(371, 454), Vector2(365, 483), Vector2(333, 494), Vector2(276, 489), Vector2(260, 477),
		Vector2(250, 455), Vector2(250, 411), Vector2(240, 370), Vector2(206, 351), Vector2(165, 358),
		Vector2(116, 370), Vector2(65, 365), Vector2(43, 337), Vector2(49, 298), Vector2(66, 274),
		Vector2(69, 263)
	]
	
	path.points = points

func _on_ClearButton_pressed():
	if not is_game_running:
		print('clear')
		path.clear_points()

func _on_DrawButton_pressed():
	if not is_game_running:
		is_drawing = !is_drawing  # Toggle drawing mode
		if is_drawing:
			$draw.text = "save"
			print("Drawing mode activated.")
		else:
			$draw.text = "draw"
			print("Drawing mode deactivated.")
		
func _input(event):
	if is_drawing and event is InputEventMouseButton and event.pressed:
		# Get the mouse position relative to the Line2D node
		var mouse_pos = get_local_mouse_position()  # Get the global mouse position
		add_point_to_path(mouse_pos)  # Add the point to the path

func add_point_to_path(position: Vector2):
	if path and position[1] < 500:  # Ensure path is valid
		path.add_point(position)  # Add the point to the Path node
		print("Point added:", position)
	else:
		print("Error: Path instance is null.")
