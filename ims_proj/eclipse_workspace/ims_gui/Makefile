LIBS = -lcurl 
all: build

build:
	g++ -std=c++17 ./src/ims_api.cpp main.cpp -o main \
	$(shell pkg-config libegt --cflags --libs) \
	-pthread $(LIBS)
unzip: 
	unzip -o ./ui.zip
run: 
	./main

test: build run