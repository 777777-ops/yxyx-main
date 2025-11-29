TOP_NAME = top

#VERILATOR配置
VERILATOR = verilator
VERILATOR_FLAGS = --cc --build -j 0 -Wall 

#构建目录
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOP_NAME)

default: build $(BIN)
	
#自动链接引脚脚本(可选)
NXDC_FILES = vsrc/top.nxdc
SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
$(SRC_AUTO_BIND) : $(NXDC_FILES)
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

#源文件
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.cpp")
CSRCS += $(SRC_AUTO_BIND)

#传递给Verilator的编译项
INCFLAGS = $(addprefix -I, $(INC_PATH))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOP_NAME)\""

include $(NVBOARD_HOME)/scripts/nvboard.mk

all: default

$(BIN): $(VSRCS) $(CSRCS) $(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_FLAGS) \
		--top-module $(TOP_NAME) $^ \
		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

build:
	mkdir -p build

run: $(BIN)
	@$^

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all default build
