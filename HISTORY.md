# Initial notes

### Observação: essas notas estão em formato rascunho, o arquivo docs/API.md contém as mesmas informações de maneira mais organizada.

* API
Express (Node.js) Não utilizado / Flask (Python)

* Infra
Servidor:
Local / Cloud
Docker / VM
Kubernetes (Minikube)

Banco:
Semi Estruturado - Ideal - Não utilizado
Abordagem anterior: MongoDB / Redis - Não utilizado
Abordagem anterior: Mysql - Não utilizado
Nova abordagem: Arquivo

* Automações
Terraform
Ansible - Não utilizado

* CI/CD
Github Actions
ArgoCD(Kube) - Não utilizado

* Monitoramento e Observabilidade
Zabbix / Alterado para prometheus
Grafana

# Considerações

## API

### Definições
* Comentários salvos em arquivo
* Adição de unit tests usando lib unittest (único teste unitario que adiciona um comentário e le, comparando se le uma unica inserção)

### Pesquisas
* Uso biblioteca Flask
* Biblioteca jsonify (Conversão para formato Json, o cliente recebe o cabeçalho corretamente)

### Melhorias
* Definir exception para requisições (Lib Flask já possui sistema que lida com erros e exceções)
* Organizar API com blueprints (URL)
* Verificar campos inseridos (Informações além dos campos email, comment e content_id)
* Validar email
* Criptografar email
* Sanitização dos dados recebidos definindo schema (Prevenção injection)
  - lib marshmallow

### Desafios
* Relembrar sintaxe e bibliotecas
* Utilizar pymongo / mysql-connector-python
* Utilizar base de dados
* Funciona local, porem nao em container. Instalei a lib gunicorn para executar
* Problemas do container estao relacionados a função get_json(), o servidor nao reconhecia a request como um json valido

## Containers

### Pesquisas
* Redes isoladas

### Deafios
* Compartilhamento de rede com máquina local (network_mode: host incompatível com Windows)
* Windows defender
* Empty reply from server

## CI/CD
* GitHub Actions
* Sem acesso ao settings do repo do Git (Secrets de read and write do Docker em aberto)

## IAC
* Terraform para criar GKE

### Desafios
* Estudar terraform e GCP
* Configurar ambos ambiente local
* Configurar provider kubernetes usando (depends on - cluster)