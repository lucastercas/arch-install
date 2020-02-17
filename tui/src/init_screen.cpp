#include "headers/init_screen.h"

using namespace init_screen;

void test_func() {}

lpstf init_screen::get_options() {
  lpstf opts = {
    std::make_pair("Format Disks", format_screen::draw_screen),
    std::make_pair("Mount Disks", &test_func),
    std::make_pair("Pacstrap Partition", test_func),
    std::make_pair("Generate Fstab", test_func),
    std::make_pair("Arch Chroot Options", test_func),
    std::make_pair("Exit", nullptr),
  };
  return opts;
}

void init_screen::draw_screen() {
  lpstf opts = get_options();
  draw_options(opts, 0);
}
