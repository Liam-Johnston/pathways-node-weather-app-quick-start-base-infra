COMPOSE_RUN_TERRAFORM = docker-compose run --rm --workdir="/opt/app/deploy" tf
COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf
COMPOSE_RUN_AWS = docker-compose run --rm --entrypoint aws tf

.PHONY: run_plan
run_plan: init plan

.PHONY: run_apply
run_apply: init apply

.PHONY: run_destroy_plan
run_destroy_plan: init destroy_plan

.PHONY: run_destroy_apply
run_destroy_apply: init destroy_apply

.PHONY: version
version:
	$(COMPOSE_RUN_TERRAFORM) --version
	
.PHONY: init
init:
	mkdir -p dist
	[ ! -f ./dist/function.zip ] && touch ./dist/function.zip || exit 0
	$(COMPOSE_RUN_TERRAFORM) init -input=false
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

.PHONY: plan
plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false

.PHONY: apply
apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"

.PHONY: destroy_plan
destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy

.PHONY: destroy_apply
destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve

.PHONY: build_self_heal
build_self_heal:
	rm -rf "dist/"
	mkdir -p dist
	docker-compose run self_healing_function_build sh \
		-c "cp -r /app/src/* /app/node_modules .; \
		apk add zip; \
		zip -rmq ./function.zip ."

.PHONY: run_self_heal
run_self_heal:
	docker-compose run self_healing_function
