#tool
extends Node


export(bool) var A_Side_Con setget A_Side_Con_set
export(bool) var B_Side_Con setget B_Side_Con_set
export(bool) var C_Side_Con setget C_Side_Con_set
export(bool) var D_Side_Con setget D_Side_Con_set
	
func _ready():
	A_Side_Con_set(A_Side_Con)
	B_Side_Con_set(B_Side_Con)
	C_Side_Con_set(C_Side_Con)
	D_Side_Con_set(D_Side_Con)

func A_Side_Con_set(state):
	A_Side_Con = state
	if self.get_node("A_Dir"):
		if state:
			self.get_node("A_Dir").show()
			self.get_node("A_Dir").collision_layer = 2
			self.get_node("A_Dir").collision_mask = 1
		else:
			self.get_node("A_Dir").hide()
			self.get_node("A_Dir").collision_layer = 0
			self.get_node("A_Dir").collision_mask = 0
	
func B_Side_Con_set(state):
	B_Side_Con = state
	if self.get_node("B_Dir"):
		if state:
			self.get_node("B_Dir").show()
			self.get_node("B_Dir").collision_layer = 2
			self.get_node("B_Dir").collision_mask = 1
		else:
			self.get_node("B_Dir").hide()
			self.get_node("B_Dir").collision_layer = 0
			self.get_node("B_Dir").collision_mask = 0
	
func C_Side_Con_set(state):
	C_Side_Con = state
	if self.get_node("C_Dir"):
		if state:
			self.get_node("C_Dir").show()
			self.get_node("C_Dir").collision_layer = 2
			self.get_node("C_Dir").collision_mask = 1
		else:
			self.get_node("C_Dir").hide()
			self.get_node("C_Dir").collision_layer = 0
			self.get_node("C_Dir").collision_mask = 0

func D_Side_Con_set(state):
	D_Side_Con = state
	if self.get_node("D_Dir"):
		if state:
			self.get_node("D_Dir").show()
			self.get_node("D_Dir").collision_layer = 2
			self.get_node("D_Dir").collision_mask = 1
		else:
			self.get_node("D_Dir").hide()
			self.get_node("D_Dir").collision_layer = 0
			self.get_node("D_Dir").collision_mask = 0
