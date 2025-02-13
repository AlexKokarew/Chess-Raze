extends Node

var server_url = "http://localhost:8080"  # URL сервера
var headers = ["Content-Type: application/json"]  # Заголовки запроса
var post_data = '{"key":"value"}'  # Данные для отправки в формате JSON

var http_request : HTTPRequest  # Переменная для HTTPRequest

func _ready():
	# Создаем объект HTTPRequest
	http_request = HTTPRequest.new()
	add_child(http_request)  # Добавляем HTTPRequest как дочерний узел

	# Подключаем сигнал завершения запроса к обработчику
	http_request.request_completed.connect(_on_request_completed)

	# Отправляем POST-запрос
	var result = http_request.request(server_url, headers, post_data, HTTPClient.Method.POST)

	if result == OK:
		print("Запрос отправлен на сервер.")
	else:
		print("Ошибка при отправке запроса.")

func _on_request_completed(result, response_code, headers, body):
	# Обработчик завершения запроса
	if result == HTTPRequest.RESULT_SUCCESS:
		print("Ответ от сервера получен.")
		var response_text = body.get_string_from_utf8()  # Преобразуем тело ответа из байтов в строку
		print("Ответ от сервера:", response_text)
	else:
		print("Ошибка при получении ответа от сервера. Код ответа:", response_code)
