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

KUBECTL= /usr/bin/kubectl
KAFKA_CREATE_TOPICS=create_topics.sh

NAMESPACE=kafka
KAFKA_CFGMAP=kafka-cfgmap  
KAFKA_CFGMAP_YAML=05kafka-cfgmap.yaml

all: build push

build:
		-@$(KUBECTL) create namespace $(NAMESPACE)
		@$(KUBECTL) create configmap $(KAFKA_CFGMAP) --from-file $(KAFKA_CREATE_TOPICS) -n $(NAMESPACE)
		@$(KUBECTL) get configmap $(KAFKA_CFGMAP) -n $(NAMESPACE) -o yaml > $(KAFKA_CFGMAP_YAML)
		@$(KUBECTL) delete configmap $(KAFKA_CFGMAP) -n $(NAMESPACE)
        
push:
		@cp $(KAFKA_CFGMAP_YAML) .. 

clean:
		-@$(KUBECTL) delete configmap $(KAFKA_CFGMAP) -n $(NAMESPACE)
		@rm -f $(KAFKA_CFGMAP_YAML)
        

