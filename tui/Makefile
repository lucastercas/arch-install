CC := g++
CFLAGS := -g -Wall
LIBS := -lncurses

SRCEXT := cpp
SRCDIR := src
BUILDDIR := build

SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SCRDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
HEADERS := -I src/headers
SOURCE := main.cpp pkg_install.cpp

TARGET := bin/install

$(TARGET): $(OBJECTS)
	@echo "Linking..."
	@echo "$(CC) $^ -o $(TARGET) $(LIBS)"
	$(CC) $^ -o $(TARGET) $(LIBS)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo "$(CC) $(CFLAGS) $(HEADERS) -c -o $@ @<"
	$(CC) $(CFLAGS) $(HEADERS) -c -o $@ @<

clean:
	@echo "Cleaning.."
	@echo "$(RM) -r $(BUILDDIR) $(TARGET) $(OBJECTS)"
	$(RM) -r $(BUILDDIR) $(TARGET) $(OBJECTS)

.PHONY: clean