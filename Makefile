TARGET_EXEC ?= exec

OUT_DIR ?= ./out
SRC_DIRS ?= ./sources/src ./sources/inc
BUILD_DIR ?= $(OUT_DIR)/build
EXEC_DIR ?= $(OUT_DIR)/exec

SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CFLAGS ?= $(INC_FLAGS) -O2 -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int \
	-Werror-implicit-function-declaration -Wmain -Wparentheses \
	-Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused \
	-Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef \
	-Wshadow -Wpointer-arith -Wbad-function-cast -Wwrite-strings \
	-Wconversion -Wsign-compare -Waggregate-return -Wstrict-prototypes \
	-Wmissing-prototypes -Wmissing-declarations -Wmissing-noreturn \
	-Wformat -Wmissing-format-attribute -Wno-deprecated-declarations \
	-Wpacked -Wredundant-decls -Wnested-externs -Winline -Wlong-long \
	-Wunreachable-code

# LDFLAGS= -L<Directory where the library resides> -l<library name>

$(EXEC_DIR)/$(TARGET_EXEC): $(OBJS)
	$(MKDIR_P) $(dir $@)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean

clean:
	$(RM) -r $(OUT_DIR)

-include $(DEPS)

MKDIR_P ?= mkdir -p
