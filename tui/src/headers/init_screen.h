#pragma once

#include "utils.h"
#include "format_screen.h"

#include <ncurses.h>

namespace init_screen {
  lpstf get_options();
  void draw_screen();
}