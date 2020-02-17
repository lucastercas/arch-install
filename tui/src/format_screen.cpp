#include "headers/format_screen.h"

using namespace format_screen;

void test_func2() {
  waddstr(stdscr, "iae");
}

lpstf format_screen::get_options() {
  lpstf options = {
    std::make_pair("List Disks and Partitions", test_func2),
    std::make_pair("Define Partition Schema", test_func2),
    std::make_pair("Format Disk", test_func2),
    std::make_pair("Mount Partitions", test_func2),
    std::make_pair("Back", test_func2),
  };
  return options;
}

void format_screen::draw_screen() {
  lpstf opts = get_options();
  draw_options(opts, 0);
}