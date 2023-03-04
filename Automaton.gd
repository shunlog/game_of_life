class_name Automaton extends Node

var GRID_W = 100
var GRID_H = 100
signal matrix_updated()

# m is a 2d array of booleans, storing the state for each cell
# nc is a 2d array of int, storing the neighbors count for each cell
# m2 and nc2 are used when going to next state, so that i declare them once

# the cells are drawn using a TileMap

var m = []
var m_prev = []
var nc = []
var nc2 = []
var grid : Grid

func _init(g : Grid = Grid.new()):
	grid = g
	grid.m = m
	pass
	
func _ready():
	for x in range(GRID_W):
		m.append([])
		nc.append([])
		for _y in range(GRID_H):
			m[x].append(false)
			nc[x].append(0)
	nc2 = nc.duplicate(true)
	m_prev = m.duplicate(true)

func step():
	m_prev = m.duplicate(true)	
	nc2 = nc.duplicate(true)
	for x in range(GRID_W):
		for y in range(GRID_H):
			if (m[x][y] and (nc2[x][y] in [2, 3])) \
				or ((!m[x][y]) and (nc2[x][y] == 3)):
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
	for dp in [[-1, -1], [-1, 0], [-1, 1],
			 [0, -1], [0, 1],
			 [1, -1], [1, 0], [1, 1]]:
		var dx = dp[0]
		var dy = dp[1]
		var nx = p.x + dx
		var ny = p.y + dy
		if _outside(Vector2(nx, ny)):
			continue
		nc[nx][ny] += 1 if val else -1
	m[p.x][p.y] = val
	grid.update()

func fill_random():
	for x in range(GRID_W):
		for y in range(GRID_H):
			set_cell(Vector2(x, y), randi() % 2 == 0)

func clear():
	for x in range(GRID_W):
		m[x].resize(GRID_H)
		m[x].fill(false)
		nc[x].resize(GRID_H)
		nc[x].fill(0)
	grid.update()
