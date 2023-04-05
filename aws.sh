
complete -C "${PYTHON_INSTALL_PATH}/aws_completer" aws

ecr-login() {
    REGION=${AWS_DEFAULT_REGION:-us-east-1}
    ACCOUNT_ID=${ACCOUNT_ID:-485185227295}
    while [ "$1" ]; do
        case $1 in
            --region )
                shift
                REGION=$1
                ;;
            -i | --id | --account-id )
                shift
                ACCOUNT_ID=$1
                ;;
            * )
                echo "Error: Unknown arg $1"
                return 1
                ;;
        esac
        shift
    done
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
}

ecr-public-login() {
    REGION=${REGION:-us-east-1}
    REGISTRY=${REGISTRY:-public.ecr.aws/m0z8a6o8}
    while [ "$1" ]; do
        case $1 in
            --region )
                shift
                REGION=$1
                ;;
            --registry )
                shift
                REGISTRY=$1
                ;;
            * )
                echo "Error: Unknown arg $1"
                return 1
                ;;
        esac
        shift
    done
    aws ecr-public get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${REGISTRY}
}
