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

KUBECTL=kubectl
CASSANDRA_ETC=etc

CFGMAP=cassandra-cfgmap  
CFGMAP_YAML=05cassandra-cfgmap.yaml

all: build push


build:
	@$(KUBECTL) create configmap $(CFGMAP) --from-file $(CASSANDRA_ETC)
	@$(KUBECTL) get configmap $(CFGMAP) -o yaml > $(CFGMAP_YAML)

push:
	@cp ${CFGMAP_YAML} .. 

clean:
	@$(KUBECTL) delete configmap $(CFGMAP)
	@rm -f ${CFGMAP_YAML}
