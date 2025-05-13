#!/bin/bash
set -e
###Проверяю на наличие сервисного аккаунта, если нет - создаём###
if ! yc iam service-account get --name $SA_NAME &>/dev/null; then
  echo "Нет сервисного пользователя $SA_NAME"
  exit 1
else
  echo "Проверяем наличие бакета (при отсутствии будет создан ${TF_STATE_BUCKET})"
fi
###проверяем наличие бакета, если нет - создаём и нарезаем права rw###
if ! yc storage bucket get --name ${TF_STATE_BUCKET} &>/dev/null; then
        echo "Создаю новый бакет: ${TF_STATE_BUCKET}"
        yc storage bucket create --name ${TF_STATE_BUCKET} \
          --default-storage-class=standard \
          --max-size=1073741824 \
          --public-read=false \
          --public-list=false &>/dev/null
            yc storage bucket update --name ${TF_STATE_BUCKET} \
            --grants="
            grantee-id=$(yc iam service-account get --name ${SA_NAME} --format json | jq -r '.id'),
            grant-type=grant-type-account,
            permission=permission-read" \
            --grants="
            grantee-id=$(yc iam service-account get --name ${SA_NAME} --format json | jq -r '.id'),
            grant-type=grant-type-account,
            permission=permission-write"
        echo "Создан бакет ${TF_STATE_BUCKET} с правами RW для ${SA_NAME}" 
else
    echo "Бакет ${TF_STATE_BUCKET} уже существует с правами RW для ${SA_NAME}"
fi
###создаём ключи доступа###
#if [ $(yc iam access-key list --service-account-name $SA_NAME --format json | jq length) -eq 0 ]; then
#  echo "Creating access keys"
#  ###делаем ключ###
#  yc iam access-key create \
#  --service-account-name $SA_NAME \
#  --folder-id=b1gpm0guidv16gd8344e \
#  --format json > cred.json
#
#  key_id=$(yc iam access-key list \
#  --service-account-name terraform-sass \
#  --folder-id=b1gpm0guidv16gd8344e \
#  --format json \
#  | jq -r 'sort_by(.created_at) | last | .key_id')
#

#  echo "BACK_KEY_ID=$(jq -r '.access_key.key_id' cred.json)" >> auth.env
#  echo "BACK_KEY_SCRT=$(jq -r '.secret' cred.json)" >> auth.env
#  rm -rf cred.json
#else
#  echo "Секретный ключ уже есть. Забыл ключ? Перевыпусти"
#  
#fi
echo "TF_VAR_token1=$(yc iam create-token)" >> auth.env