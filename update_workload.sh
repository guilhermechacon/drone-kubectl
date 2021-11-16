#### Testes de variáveis pré execução
## WORKLOAD = nome do repositório
if [ -z ${PLUGIN_WORKLOAD} ]; then
  echo "missing Workload name"
  exit 1
fi

## UPDATES_IMAGE = imagem atualizada no ECR
if [ -z ${PLUGIN_UPDATED_IMAGE} ]; then
  echo "missing image"
  exit 1
fi

## NAMESPACE = name space do workload
if [ -z ${PLUGIN_NAMESPACE} ]; then
  echo "missing Namespace"
  exit 1
fi

## CLUSTER = Cluster configured in k8s config file
if [ -z ${PLUGIN_CLUSTER} ]; then
  echo "missing Cluster"
  exit 1
fi

## USER = User configured in k8s config file
if [ -z ${PLUGIN_USER} ]; then
  echo "missing User"
  exit 1
fi

#### Criação do arquivo de conf V1
mkdir .kube
cd .kube
PWD=$(pwd)/config
#    SERVER
    kubectl config --kubeconfig=config set-cluster local --server=${PLUGIN_SERVER}
#    USER
    kubectl config --kubeconfig=config set-credentials local --token=${PLUGIN_TOKEN}
#    CONTEXT
    kubectl config --kubeconfig=config set-context local --cluster=${PLUGIN_CLUSTER} --user=${PLUGIN_USER} --namespace=${PLUGIN_NAMESPACE}
#    CURRENT CONTEXT
    kubectl config --kubeconfig=config use-context local

#### Primeiro Comando kubectl V1
kubectl --kubeconfig=${PWD} rollout restart deploy ${PLUGIN_WORKLOAD} -n ${PLUGIN_NAMESPACE}
