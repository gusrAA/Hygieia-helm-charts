CHART_NAME := $(shell grep -oP '(?<=name: ).*' Chart.yaml)
CHART_VERSION := $(shell grep -oP '(?<=version: ).*' Chart.yaml)
CHART_DIR := build/$(CHART_NAME)

PACKAGE_NAME := $(CHART_NAME)-$(CHART_VERSION).tgz

build: stage check
	if [[ ! -f build/$(PACKAGE_NAME) ]]; then cd build/; helm package $(CHART_NAME); fi

stage:
	if [[ ! -d ./$(CHART_DIR) ]]; then mkdir -p $(CHART_DIR); fi
	cp -R *.yaml templates/ *.lock $(CHART_DIR) || :
	if [[ -f ./$(CHART_DIR)/requirements.yaml ]]; then helm dep build $(CHART_DIR); fi

template: stage
	helm template $(CHART_DIR)

check: stage
	helm lint $(CHART_DIR)

clean:
	rm -rf build/

upload: build
	curl -T build/$(PACKAGE_NAME) -X PUT https://helmet.ekaas.qcorpaa.aa.com/upload/
