#pragma once

#include "utils.h"

#include <ncurses.h>
#include <sys/statvfs.h>
#include <sys/sysinfo.h>

#include <iostream>

namespace format_screen {
  void list();
  lpstf get_options();
  void draw_screen();
}