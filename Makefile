.PHONY: run
run:
ifndef PORT
	$(error port is not set)
endif

ifndef NODE
	$(error node is not set)
endif

ifndef CLUSTER
	PORT=$(PORT) iex --name $(NODE) --cookie 'logger' -S mix phx.server
endif

	PORT=$(PORT) CLUSTER=$(CLUSTER) iex --name $(NODE) --cookie 'logger' -S mix phx.server

.PHONY: test
test:
	mix test --trace