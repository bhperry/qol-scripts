
complete -C "${PYTHON_INSTALL_PATH}/aws_completer" aws 

ecr-login() {
    REGION=${1:-us-east-2}
    ACCOUNT_ID=${2:-485185227295}
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
}