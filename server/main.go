package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()
	app.Static("/", "../website/public")

	// send custom 404 file
	app.Use(func(c *fiber.Ctx) error {
		return c.Status(fiber.StatusNotFound).SendFile("../website/public/404.html")
	})

	log.Fatal(app.Listen(":3000"))
}
