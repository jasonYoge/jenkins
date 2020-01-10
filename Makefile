tagname := "jenkins"
local_terraform := "kubernetes.tfstate"

.PHONY: docker-build docker-publish
docker-build:
	@docker build \
		--build-arg INPUT_JENKINS_USER=admin \
		--build-arg INPUT_JENKINS_PASS=password \
		-t $(tagname) \
		-f ./jenkins/Dockerfile.jenkins ./jenkins

docker-publish:
	@docker login
	@docker tag $(tagname):latest jasonyoge/$(tagname)
	@docker push jasonyoge/$(tagnameu)

.PHONY: run-local delete-local
run-local:
	@cd ./terraform && \
		terraform init && \
		terraform plan && \
		terraform apply -auto-approve
	@echo "\nJenkins Server is now running at: \033[92mhttp://`minikube ip`:30000\n"

delete-local:
	@cd ./terraform && \
		terraform destroy -auto-approve -target kubernetes_deployment.jenkins -target kubernetes_service.jenkins
