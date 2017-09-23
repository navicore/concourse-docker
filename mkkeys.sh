#!/bin/sh

ROOT_DIR="/"

: ${KEYS_DIR:="${ROOT_DIR}/concourse-keys/"}
: ${SESSION_SIGNING_KEY_NAME:='session_signing_key'}
: ${TSA_HOST_KEY_NAME:='tsa_host_key'}
: ${WORKER_KEY_NAME:='worker_key'}
: ${AUTHORIZED_WORKER_KEYS_NAME:='authorized_worker_keys'}

gen_key() (
  mkdir -p "${KEYS_DIR}"
  cd "${KEYS_DIR}"

  for k; do
    [ -f "${KEYS_DIR}/$k" ] && continue

    echo "Generating $k ..."
    ssh-keygen -q -t rsa -f $k -N ''
  done
)

key_path() {
  echo "${KEYS_DIR}/$*"
}

gen_key ${SESSION_SIGNING_KEY_NAME} ${TSA_HOST_KEY_NAME} ${WORKER_KEY_NAME}
cat < "${KEYS_DIR}/${WORKER_KEY_NAME}.pub" >> "${KEYS_DIR}/${AUTHORIZED_WORKER_KEYS_NAME}"

