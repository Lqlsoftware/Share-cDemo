.PHONY: clean demo run build
default: build

# Arch of env
ARCH = $(shell uname -s)
LINUX = Linux
DARWIN = Darwin

# Project, source, and build paths
PROJECT_ROOT := $(shell pwd)
BUILD_DIR := $(PROJECT_ROOT)/bin
GO_SRC_DIR := $(PROJECT_ROOT)/src/go
C_SRC_DIR := $(PROJECT_ROOT)/src/c
DOTNET_SRC_DIR := $(PROJECT_ROOT)/src/dotNET

# Golang lib names
DEMO_WINDOWS := libdemo_windows.dll
DEMO_WINDOWS_HEADER := libdemo_windows.h
DEMO_LINUX := libdemo_linux.so
DEMO_LINUX_HEADER := libdemo_linux.h
DEMO_DARWIN := libdemo_darwin.dylib
DEMO_DARWIN_HEADER := libdemo_darwin.h

# Executable names
DEMO_C := demo_c
DEMO_DOTNET := dotNET

# Complier
CC ?= gcc
CXX ?= g++
CC_FLAGS := -g -O2
CXX_FLAGS := -g -O2



# Golang lib
demo-windows:
	GOHOSTOS=windows GOHOSTARCH=amd64 CGO_ENABLED=1 go build -i -x -v -ldflags "-s -w" -buildmode=c-shared -o $(BUILD_DIR)/$(DEMO_WINDOWS) $(GO_SRC_DIR)/*.go

demo-linux:
	GOHOSTOS=linux GOHOSTARCH=amd64 CGO_ENABLED=1 go build -i -x -v -ldflags "-s -w" -buildmode=c-shared -o $(BUILD_DIR)/$(DEMO_LINUX) $(GO_SRC_DIR)/*.go

demo-darwin:
	GOHOSTOS=darwin GOHOSTARCH=amd64 CGO_ENABLED=1 go build -i -x -v -ldflags "-s -w" -buildmode=c-shared -o $(BUILD_DIR)/$(DEMO_DARWIN) $(GO_SRC_DIR)/*.go

demo: demo-windows \
	demo-linux \
	demo-darwin

demo-no-unix: demo-windows \

demo-no-windows: demo-linux \
	demo-darwin \

# C-executable
demo-c:
	@if [ $(ARCH) = $(DARWIN) ]; \
	then \
		$(CC) $(CC_FLAGS) $(C_SRC_DIR)/*.c -o $(BUILD_DIR)/$(DEMO_C) -I $(BUILD_DIR) -L $(BUILD_DIR) -ldemo_darwin; \
	elif [ $(ARCH) = $(LINUX) ]; \
	then \
		$(CC) $(CC_FLAGS) $(C_SRC_DIR)/*.c -o $(BUILD_DIR)/$(DEMO_C) -I $(BUILD_DIR) -L $(BUILD_DIR) -ldemo_linux; \
	else \
		$(CC) $(CC_FLAGS) $(C_SRC_DIR)/*.c -o $(BUILD_DIR)/$(DEMO_C) -I $(BUILD_DIR) -L $(BUILD_DIR) -ldemo_windows; \
	fi

demo-dotNET:
	cd $(DOTNET_SRC_DIR) && dotnet build -o $(BUILD_DIR)

run-demo-c:
	cd $(BUILD_DIR) && env LD_LIBRARY_PATH=$(BUILD_DIR)  $(BUILD_DIR)/$(DEMO_C);

run-demo-dotNET:
	cd $(BUILD_DIR) && $(BUILD_DIR)/$(DEMO_DOTNET)

all: build \
	run

build: demo \
	demo-c \
	demo-dotNET

run: run-demo-c \
	run-demo-dotNET

# Clean
clean:
	# dll files
	rm -f $(BUILD_DIR)/$(DEMO_WINDOWS)
	rm -f $(BUILD_DIR)/$(DEMO_LINUX)
	rm -f $(BUILD_DIR)/$(DEMO_DARWIN)

	# header files
	rm -f $(BUILD_DIR)/$(DEMO_WINDOWS_HEADER)
	rm -f $(BUILD_DIR)/$(DEMO_LINUX_HEADER)
	rm -f $(BUILD_DIR)/$(DEMO_DARWIN_HEADER)

	# executable files
	rm -Rf $(BUILD_DIR)/$(DEMO_C)*
	rm -Rf $(BUILD_DIR)/$(DEMO_DOTNET)*

