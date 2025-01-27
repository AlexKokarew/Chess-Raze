package main

import (
	"fmt"
	"log"

	"github.com/gen2brain/raylib-go/raylib"
)

func main() {
	// Инициализация окна
	rl.InitWindow(800, 600, "Chess Game")
	defer rl.CloseWindow() // Закрытие окна после завершения работы

	// Инициализация камеры
	camera := rl.Camera3D{
		Position:  rl.NewVector3(4.0, 4.0, 4.0), // Позиция камеры
		Target:    rl.NewVector3(0.0, 0.0, 0.0), // Камера направлена на эту точку
		Up:        rl.NewVector3(0.0, 1.0, 0.0), // Ось вверх
		Fovy:      45.0,                          // Угол поля зрения
		Projection: rl.Perspective,               // Перспективная проекция
	}

	// Главный игровой цикл
	for !rl.WindowShouldClose() {
		// Обновление камеры
		rl.UpdateCamera(&camera)

		// Очищаем экран
		rl.BeginDrawing()
		rl.ClearBackground(rl.RayWhite)

		// Отображаем 3D сцену
		rl.BeginMode3D(camera)
		// Рисуем куб на позиции (0, 0, 0)
		rl.DrawCube(rl.NewVector3(0, 0, 0), 2, 2, 2, rl.Red)
		rl.EndMode3D()

		// Отображение текста на экране
		rl.DrawText("3D Camera Example", 10, 10, 20, rl.DarkGray)

		// Завершаем рисование
		rl.EndDrawing()
	}

	// Закрытие программы
	log.Println("Программа завершена!")
}
