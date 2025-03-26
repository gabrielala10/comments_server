# API de Comentários

Essa é uma API com dois endpoints principais:

/api/comment/new - Endpoint para inserir um novo comentário.

/api/comment/list/<<id>> - Emdpoint para listar com um determinado id.


Foi criado um endpoint extra para debugar conexões:

/test -> Resposta: "OK", 200

## Ideia inicial
Para a ideia inicial de construir uma API em Python utilizando a lib Flask com um banco de dados MongoDB, essa API deve estar em um cluster GKE (Google Kubernetes Engine) e também estar aberta para receber requisições externas (Ingress). Esse cluster será criado utilizando o Terraform, juntamente com seus namespaces, um chamado application e outro monitoring, o segundo é dedicado ao prometheus e ao grafana. Sobre o CICD, existem duas possibilidades, o modo "Build once, deploy many" e o padrão GitOps.

![DiagramaDeArquitetura](https://github.com/user-attachments/assets/fdae61b0-c131-44a5-86a2-5c9f068cb7cf)

## API
A API foi desenvolvida em Python, usando a lib Flask e gunicorn para expor os endpoints e executar o servidor, a lib jsonify para tratar os dados json recebidos e enviados. Além disso utilizei prometheus_flask_exporter para exportar as métricas do servidor.

Os dados inseridos não são validados ou criptografados, não explorei possíveis excessões das funções utilizadas e além disso não consegui utilizar uma base de dados devido a problemas de integração, os comentários enviados e listados são registrados em um arquivo na própria API chamado comments.txt

![DiagramaDeArquiteturaReal](https://github.com/user-attachments/assets/c6630486-4634-47d3-8b13-d678ba972391)

Para testar a api utilize os seguintes comandos após utilizar docker compose up:

```
# matéria 1
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"first post!","content_id":1}'

# matéria 2
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I guess this is a good thing","content_id":2}'

# listagem matéria 1
curl -sv localhost:8000/api/comment/list/1

# listagem matéria 2
curl -sv localhost:8000/api/comment/list/2
```

Se estiver usando Windows utilize:

```
# matéria 1
curl -sv localhost:8000/api/comment/new -X POST -H "Content-Type: application/json" -d "{\"email\":\"alice@example.com\",\"comment\":\"first post!\",\"content_id\":1}"

# matéria 2
curl -sv localhost:8000/api/comment/new -X POST -H "Content-Type: application/json" -d "{\"email\":\"bob@example.com\",\"comment\":\"I guess this is a good thing\",\"content_id\":2}"

# listagem matéria 1
curl -sv localhost:8000/api/comment/list/1

# listagem matéria 2
curl -sv localhost:8000/api/comment/list/2
```
Se estiver conectado no GKE, voce precisa fazer o login no google cloud shell e depois disso utilizar o seguinte comando para se conectar no cluster:

```
gcloud container clusters get-credentials selecao --zone us-central1-a --project comments-440520
```

Após isso utilize os comandos get pods e exec para fazer o curl de dentro do pod client:

```
kubectl get pods -n application
kubectl exec -it <client-pod> -n application -- /bin/sh
```

Após isso pode utilizar os comandos de curl demonstrados acima, somente subistituindo o localhost pelo nome do service *comments-service*

## IAC
Eu utilizei o Terraform para fazer o deploy de um cluster GKE, tive problemas relacionados a criação de namespaces, pois como ainda não tinha o kubeconfig do kube, o cluster não aceitava essa criação, não consegui usar o campo "depends on" no terraform para contornar isso. A solução foi criar o cluster, após a criação salvei a config dos novos namespaces e utilizei o terraform apply.

Quanto aos arquivos de configuração do kube, criei uma pasta com o kustomize, o deploy da API e o service. Na pipeline de deploy aponto a pasta a ser instalada.

O deploy do client foi criado utilizando o seguinte comando no próprio kube:

```
kubectl create deployment client --image=curlimages/curl -n application -- /bin/sh -c "while true; do sleep 30; done"
```

## CI/CD
Utilizei o github actions para CI/CD, tenho dois arquivos de pipeline, um com o teste unitário e outra com as pipelines de build e deploy.

![DiagramaDeDesenvolvimento](https://github.com/user-attachments/assets/cb9f77c7-69a0-4af6-9f87-9b11650fa4b4)

Teste unitário:
É uma pipeline simples que rodo o arquivo test_main.py. Esse arquivo insere um comentário e verifica se no endpoint de listar temos somente um comentário. Em certo momento testei criar uma pipeline que inseria esse comentário duas vezes, ela falhou como o esperado.

Build e deploy:
Para buildar e publicar essa imagem no docker repo precisei adicionar minhas credenciais do Docker no git, como nao tenho permissões no git repo nao consegui salvar secrets. Após a build a pipe faz o deploy da mesma imagem (A tag é a hash do commit) no GKE, utilizando o kubeconfig para se autenticar, nesse kubeconfig tem um token que expira após 1 hora, para gerar utilize o seguinte comando no gcloud shell após fazer login:
```
gcloud auth print-access-token
```
## Monitoramento
Para monitorar não foi possível colocar o prometheus e o grafana no GKE, devido a restrição de recursos. Então no dockercompose eu coloquei a configuração para subir ambos, consegui também configurar para o grafana já registrar o prometheus no endereço http://prometheus:9090 como datasource.

Não consegui colocar o dashboard que criei no repo, pois fiz testes apagando o volume criado e subindo com o dashboard.json nos volumes, mas o dashboard apareceu em branco por nao encontrar o datasource, abaixo segue o print do gráfico de health que criei:

![Captura de tela 2024-11-07 221554](https://github.com/user-attachments/assets/96cf5930-0933-4a9c-8ffa-b12bce4d1a3b)

Métrica utilizada:
up{instance="api:8000"}

## Rodar localmente
Para rodar localmente basta utilizar docker compose up, dessa forma conseguirá fazer requests do seu ambiente local para o container de API com as instruções descritas no tópico *API*

O grafana pode ser acessado em:
localhost:3000

Para apagar o volume salvo do grafana utilize: docker compose down -v

## Melhorias

* Utilizar um banco de dados semi estruturado (Mongo)
* Validar dados recebidos (email, mensagem e id)
* Fazer a sanitização dos dados para previnir injection
* Verificar exceções
* Inserir logs úteis na API
* Criar testes unitários que realmente validem se os dados inseridos estão corretos e não somente quantos objetos ele inseriu
* Guardar as secrets de maneira segura e não aberta no código
* Expor a API para a rede (Ingress)
* Criar um domínio
* Monitorar a API no GKE
* Monitorar a saúde do GKE
* Utilizar ArgoCD para monitorar deployments e versões no kube
* Solicitar login para utilizar a API

## Ferrantas novas ou que precisei relembrar

* Terraform
* GKE
* Prometheus
* Git Actions
* Python - Relembrar
* GCP - Relembrar
