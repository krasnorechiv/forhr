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

if ! yc storage bucket get --name ${TF_S3_BUCKET} &>/dev/null; then
        echo "Создаю новый бакет: ${TF_S3_BUCKET}"
        yc storage bucket create --name ${TF_S3_BUCKET} \
          --default-storage-class=standard \
          --max-size=1073741824 \
          --public-read=true \
          --public-list=true &>/dev/null
            yc storage bucket update --name ${TF_S3_BUCKET} \
            --grants="
            grantee-id=$(yc iam service-account get --name ${SA_NAME} --format json | jq -r '.id'),
            grant-type=grant-type-account,
            permission=permission-read" \
            --grants="
            grantee-id=$(yc iam service-account get --name ${SA_NAME} --format json | jq -r '.id'),
            grant-type=grant-type-account,
            permission=permission-write"
        echo "Создан бакет ${TF_S3_BUCKET} с правами RW для ${SA_NAME}" 
else
    echo "Бакет ${TF_S3_BUCKET} уже существует с правами RW для ${SA_NAME}"
fi


echo "TF_VAR_token1=$(yc iam create-token)" >> auth.env