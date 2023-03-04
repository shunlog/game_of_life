class_name Automaton extends Node

var GRID_W = 50
var GRID_H = 50

# m is a 2d array of booleans, storing the state for each cell
# nc is a 2d array of int, storing the neighbors count for each cell
# m2 and nc2 are used when going to next state, so that i declare them once

# the cells are drawn using a TileMap

var m = []
var m2 = []
var nc = []
var nc2 = []

func _ready():
	for x in range(GRID_W):
		m.append([])
		nc.append([])
		for _y in range(GRID_H):
			m[x].append(false)
			nc[x].append(0)

func step():
#	var tmp = m2
#	m2 = m
#	m = tmp
	m2 = m.duplicate(true)
	nc2 = nc.duplicate(true)
	for x in range(GRID_W):
		for y in range(GRID_H):
			if (m2[x][y] and (nc2[x][y] in [2, 3])) \
				or ((!m2[x][y]) and (nc2[x][y] == 3)):
				set_cell(Vector2(x, y), true)
			else:
				set_cell(Vector2(x, y), false)

func _outside(p: Vector2):
	return p.x >= GRID_W or p.x < 0 or p.y >= GRID_H or p.y < 0
	
func toggle_cell(p: Vector2):
	if _outside(p):
		return
	set_cell(p, !m[p.x][p.y])
	
func set_cell(p: Vector2, val: bool):
	if _outside(p) or val == m[p.x][p.y]:
		return
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue
			var nx = p.x + dx
			var ny = p.y + dy
			if _outside(Vector2(nx, ny)):
				continue
			nc[nx][ny] += 1 if val else -1
	m[p.x][p.y] = val

func set_tilemap(t: TileMap):
	for x in range(GRID_W):
		for y in range(GRID_H):
			t.set_cell(x, y, 0 if m[x][y] else -1)

func fill_random():
	for x in range(GRID_W):
		for y in range(GRID_H):
			set_cell(Vector2(x, y), randi() % 2 == 0)
