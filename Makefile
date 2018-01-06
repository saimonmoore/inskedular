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
release:
	mix deps.clean --all; mix deps.get; MIX_ENV=prod mix compile; cd assets; yarn deploy; cd ..; mix phx.digest; MIX_ENV=prod mix ecto.migrate; MIX_ENV=prod mix release
deploy_fg:
	PORT=4001 HOSTNAME=localhost _build/prod/rel/inskedular/bin/inskedular foreground
deploy:
	PORT=4001 HOSTNAME=localhost _build/prod/rel/inskedular/bin/inskedular start
deploy_stop:
	PORT=4001 HOSTNAME=localhost _build/prod/rel/inskedular/bin/inskedular start
prod_console:
	_build/prod/rel/inskedular/bin/inskedular console

.PHONY: help start db_reset console release deploy_fg deploy deploy_stop prod_console
