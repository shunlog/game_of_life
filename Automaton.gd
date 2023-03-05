class_name Automaton extends Node

var GRID_W = 100
var GRID_H = 100

# m is a 2d array of booleans, storing the state for each cell
# nc is a 2d array of int, storing the neighbors count for each cell
# nc2 is used when going to next state, so that i declare it once
# we only need to keep track of previous neighbor count, previous state doesn't matter

# the cells are drawn on a Grid

var m := []
var nc := []
var nc2 := []
var grid : Grid
var rules := {Global.Rules.survival: [2, 3], Global.Rules.birth: [3]}

func _init(g : Grid = Grid.new()):
	grid = g
	grid.m = m

func _ready():
	for x in range(GRID_W):
		m.append([])
		nc.append([])
		for _y in range(GRID_H):
			m[x].append(false)
			nc[x].append(0)
	nc2 = nc.duplicate(true)

func step():
	nc2 = nc.duplicate(true)
	for x in range(GRID_W):
		for y in range(GRID_H):
			if !m[x][y] and nc2[x][y] in rules[Global.Rules.birth]:
				set_cell(Vector2(x, y), true)
			elif m[x][y] and not nc2[x][y] in rules[Global.Rules.survival]:
				set_cell(Vector2(x, y), false)


func toggle_cell(p: Vector2):
	p = _wrap(p)
	set_cell(p, !m[p.x][p.y])

func _wrap(p: Vector2):
	p.x = int(p.x) % GRID_W
	p.y = int(p.y) % GRID_H
	return p

func set_cell(p: Vector2, val: bool):
	p = _wrap(p)
	if val == m[p.x][p.y]:
		return
	for dp in [[-1, -1], [-1, 0], [-1, 1],
			   [0, -1], [0, 1],
			   [1, -1], [1, 0], [1, 1]]:
		var nx = int(p.x + dp[0]) % GRID_W
		var ny = int(p.y + dp[1]) % GRID_H
		nc[nx][ny] += 1 if val else -1
	m[p.x][p.y] = val
	grid.update()

func fill_random(rand:=.5):
	for x in range(GRID_W):
		for y in range(GRID_H):
			set_cell(Vector2(x, y), randf() < rand)

func clear():
	for x in range(GRID_W):
		m[x].resize(GRID_H)
		m[x].fill(false)
		nc[x].resize(GRID_H)
		nc[x].fill(0)
	grid.update()
