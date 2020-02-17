#pragma once

#include <vector>
#include <utility>
#include <string>

#include <ncurses.h>
#include <stdlib.h>

// Type Definitions
typedef void (*fType)();
typedef std::vector<std::string> lst;
typedef std::vector<std::pair<std::string, fType > > lpstf;

void draw_options(lpstf, int);
void draw_border();
