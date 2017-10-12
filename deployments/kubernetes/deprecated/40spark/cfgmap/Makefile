#
#   Copyright 2017 Intel Corporation
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#    

KUBECTL= kubectl
MASTER_CONF=master_conf
WORKER_CONF=worker_conf

NAMESPACE=spark
MASTER_CFGMAP=spark-master-cfgmap  
MASTER_CFGMAP_YAML=05spark-master-cfgmap.yaml
WORKER_CFGMAP=spark-worker-cfgmap  
WORKER_CFGMAP_YAML=06spark-worker-cfgmap.yaml


all: build push



build:
	-@$(KUBECTL) create namespace $NAMESPACE
	@$(KUBECTL) create configmap $(MASTER_CFGMAP) --from-file $(MASTER_CONF) -n $NAMESPACE
	@$(KUBECTL) create configmap $(WORKER_CFGMAP) --from-file $(WORKER_CONF) -n $NAMESPACE
	@$(KUBECTL) get configmap $(MASTER_CFGMAP) -n $NAMESPACE -o yaml > $(MASTER_CFGMAP_YAML)
	@$(KUBECTL) get configmap $(WORKER_CFGMAP) -n $NAMESPACE -o yaml > $(WORKER_CFGMAP_YAML)
	@$(KUBECTL) delete configmap $(MASTER_CFGMAP) -n $NAMESPACE
	@$(KUBECTL) delete configmap $(WORKER_CFGMAP) -n $NAMESPACE

push:
	@cp $(MASTER_CFGMAP_YAML) .. 
	@cp $(WORKER_CFGMAP_YAML) .. 

clean:
	-@$(KUBECTL) delete configmap $(MASTER_CFGMAP) -n $NAMESPACE
	-@$(KUBECTL) delete configmap $(WORKER_CFGMAP) -n $NAMESPACE
	@rm -f $(MASTER_CFGMAP_YAML)
	@rm -f $(WORKER_CFGMAP_YAML)
