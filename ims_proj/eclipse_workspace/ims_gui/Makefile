LIBS_ONLY = -lcurl 
PKG_CONFIG_LIBS = $(shell pkg-config libegt --cflags --libs) \
$(shell pkg-config nlohmann_json --cflags --libs) \
$(shell pkg-config opencv --cflags --libs)

#Targets

all: build

build:
	g++ -std=c++17 ./src/ims_api.cpp main.cpp -o main \
	$(PKG_CONFIG_LIBS) \
	-pthread $(LIBS_ONLY)
unzip: 
	unzip -o ./ui.zip
run: 
	./main

test: build run