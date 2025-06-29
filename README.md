# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

# **Описание репозитория**:
Пельменная. Код собирается, компилируется и отправляется в два репозитория - docker-registry и в nexus в виде: бэкэнд - бинарных файлов, фронтенд - в виде tar-архива. Далее, в зависимости от нахождения в ветке - создаётся инфраструктура и автоматически деплоится приложение на созданные terraform'ом виртуальные машины. Реализован деплой green-blue, что уменьшает простои при деплое. В целом приложения готовы для работы в k8s-кластере, однако решено делать деплой через виртуальные машины.  
**Инфа для наставника**
 - prod:
   - pelmennaya: 62.84.114.47 
   - grafana: 62.84.114.47:3000 administrator (secureadmin)  
 - dev:
   - pelmennaya: 158.160.120.234
   - grafana: 158.160.120.234:3000 administrator (secureadmin)
   
# **Устройство репозитория**:

 - **backend**: исходники бэкэнда пельменной
  Помимо исходников, содержит в себе Dockerfile
 - **frontend**: исходники фронтенда пельменной
  Помимо исходников, содержит в себе Dockerfile
 - **repo**: исходники ias (ansible terraform)



# **Как работать с репозиторием**:
 - Используем для работы с репозиторием git flow. По мере возрастания сложности и объёмности проекта перейдем на gitlab flow.    
 - В репозитории не хранятся никакие чувствительные данные (даже initial logins etc) - пока что все чувствительные данные пишем в переменные gitlab env и ставим атрибут masked (по возможности кодируем в base64). По мере выделения больших средств - перейдём на хранение секретов в Vault
 - Инфраструктура модифицируется только для main develop веток. По мере возрастания финансовых возможностей будет возможность создавать виртуальные машины для каждой ветки.
 - Используем правила версионирования sem-ver. Меняем версию приложения( в gitlab-ci) только тогда, когда готовы закрывать релиз и мерджить с main-веткой



# **Пайплайн сборки, запуска приложения и инфраструктуры**:

## _Заполняем переменные_:

 - Для CI процесса сборки (prepare,build,test): требуется заполнить обязательные переменные:
Создать в Сонаре проект проверки бэкэнда\фронтенда:
```
    ${SONAR_PROJECT_KEY_BACK}
    ${SONARQUBE_DIR} 
    ${SONARQUBE_URL} 
    ${SONAR_LOGIN}
    ${GO_VERSION}
    ${NODE_VERSION}
```

 - Для CD(delivery) процесса сборки (release-binary, docker-gen-image): требуется заполнить обязательные переменные:
```
    ${NEXUS_REPO_USER}
    ${NEXUS_REPO_PASS}
    ${NEXUS_REPO_URL}
    ${NEXUS_REPO_FRONTEND_NAME}
```

----
**Примечение**: 
- После отправки изменений в репозиторий, запустится пайплайн, который соберёт приложение и заботливо отправит бинарники в нексус, Docker-образы в Gitlab-registry
- Задачи по созданию инфраструктуры запустятся после того как будет осуществлён мердж веток в main или в develop. Или будут вливаться изменения напрямую в ветки main или develop (что не приветствуется так как используем git-flow). 
----

# **Подробное описание этапов Deployment**

## Для IaS и СD (deployment) процесса сборки (create-auth, create-machine, connect-to-machine) требуется заполнить обязательные переменные:
```
    ${YC_OATH_ID} - ключ авторизации для инфры
    ${TF_S3_BUCKET} - имя s3 бакет
    ${TF_STATE_BUCKET} - имя бакета
    ${TF_VAR_cloud_id} - id облака инфраструктуры
    ${TF_VAR_folder_id} - id директории инфраструктуры
    ${SA_NAME} - имя сервисного аккаунта
    ${GRAFANA_LOGIN} - первоначальный логин для grafana
    ${GRAFANA_PASSWD} - первоначальный пароль для grafana
    ${AWS_ACCESS_KEY_ID} - ключ-id для баккета
    ${AWS_SECRET_ACCESS_KEY} - секретный ключ для бакета
    ${SSH_ID_RSA} - base64 ключ ssh для ansible (на время создания инфры)
```

**Создание данных для аутентификации в Yandex-Cloud**: 
- Этап _create-auth_ может создать бакет, но требуется вручную запросить ключи бакета и передать их как Gitlab переменные. Наиболее оптимальный вариант - **заранее** определится с именем бакета, создать бакет и скопировать ключи - так как они **показываются один раз при создании**.
- В скрипте _create-auth_ идёт проверка на наличие бакета, и при наличии он не будет создавать ещё один бакет. Так же в _create-auth_ создаётся публичный бакет для картинок.
- В скрипте _create-auth_ передаётся в переменную TF_VAR_token1 iam токен яндекса для terraform.


**Как создаётся инфраструктура - Terraforming:**
После того как отработал этап _create-auth-and-bucket_ и отдал необходимые переменные аутентификации, идёт этап **терраформинга**:

**Как происходит терраформинг**: 
- Для задачи терраформинга выстроены условия старта задачи. В условиях для каждой ветки прописаны переменные, которые в свою очередь задают терраформу имя вм, имя сети, подстраивают окружение.
- в конце задачи терраформинга - срабатывает output-модуль сети, который помещается в переменную Public_IP, которая требуется для этапа _connect-to-machine_  (ansible)

**Установка пельменной через Ansible**
- Как было оговорено в предыдущих шагах, inventory заполняется автоматически через переменную PUBLIC_IP. Все необходимые переменные  для задач заданы через GitLab Environments. В дальнейшем будет разделение переменных для разных веток.
- Требуется заполнить cloud-init и передать закрытый ключ в переменную GitLab Environment
- Задачи разделены логически и выполняются в порядке: all-check, _модуль_, monitoring:
  - all-check - устанавливается docker, создаётся сеть пельменной.
  - модуль - устанавливается компонент пельменной
  - monitoring - устанавливается prometheus, grafana, node exporter. - Node exporter установлен в виде контейнера, что не круто и надо установить вне контейнера, так как некоторые метрики характерны для контейнера, а не для всей виртуальной машины (jail as is). 


# Сборка приложения из исходников и запуск:


## Frontend

```bash
npm install
NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run serve
```

## Backend

```bash
go run ./cmd/api
go test -v ./... 
```

## Запуск приложений пельменной через контейнеры Docker:

**Бэкэнд**:
```
docker run -d image_of_pelmennaya-backend --network pelmennaya-net --network-alias pelmennaya-backend-active
```

**Фронтенд**:
```
docker run -d image_of_pelmennaya-frontened --network pelmennaya-net -p 80:80
```

Коты: V
```

                      /^--^\     /^--^\     /^--^\
                      \____/     \____/     \____/
                     /      \   /      \   /      \
                    |        | |        | |        |
                     \__  __/   \__  __/   \__  __/
|^|^|^|^|^|^|^|^|^|^|^|^\ \^|^|^|^/ /^|^|^|^|^\ \^|^|^|^|^|^|^|^|^|^|^|^|
| | | | | | | | | | | | |\ \| | |/ /| | | | | | \ \ | | | | | | | | | | |
| | |f|m|d|x|7| | | | | / / | | |\ \| | | | | |/ /| | | | | | | | | | | |
| | | | | | | | | | | | \/| | | | \/| | | | | |\/ | | | | | | | | | | | |
#########################################################################
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
```