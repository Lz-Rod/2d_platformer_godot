extends Camera2D

var target: Node2D 

func _ready() -> void:
	get_target()

func _process(_delta: float) -> void:
	position = target.position #aqui a posição pega a posição do target e fará a camera seguir o player

func get_target():
	var nodes = get_tree().get_nodes_in_group("g-player") #aqui crio uma variavel que busca todos os nós onde tem a arvore de objetos que estãoo no grupo g-player
	if nodes.size() == 0:
		push_error("player não encontrado")
		return
	
	target = nodes[0] #aqui a variavel target recebe os nodes que estão na posição zero
