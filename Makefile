help:
	@echo "usage: make <command>"
	@echo ""
	@echo "   db_reset          Resets read and event stores
	@echo "   start             To start the application"
	@echo "   console           To open a console
	@echo ""

start:
	mix phx.server
db_reset:
	mix do ecto.reset;mix do event_store.reset
console:
	iex -S mix

.PHONY: help start db_reset console
