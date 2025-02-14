extends Node

var server_url = "http://localhost:8080/api"  # URL сервера
var headers = ["Content-Type: application/json"]  # Заголовки запроса
var post_data = '{"key":"value"}'  # Данные для отправки в формате JSON

var http_request: HTTPRequest  # Переменная для HTTPRequest

func _ready():
	# Создаем объект HTTPRequest
	http_request = HTTPRequest.new()
	add_child(http_request)  # Добавляем HTTPRequest как дочерний узел
