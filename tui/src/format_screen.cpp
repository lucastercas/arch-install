#include "headers/format_screen.h"

using namespace format_screen;

void test_func2() {
  waddstr(stdscr, "iae");
}

void format_screen::list() {
  struct statvfs fsinfo;
  statvfs("/", &fsinfo);

  long long frsize = fsinfo.f_frsize;
  long long blocks = fsinfo.f_blocks;
  long long bavail = fsinfo.f_bavail;
  long long bsize = fsinfo.f_bsize;

  std::cout << "Total Size: " << frsize * blocks << std::endl;
  std::cout << "Free: " << bsize * bavail << std::endl;
  long percent = bavail * 100 / blocks * bsize / frsize;
  std::cout << "Percent: " << percent << std::endl;
}

lpstf format_screen::get_options() {
  lpstf options = {
    std::make_pair("List Disks and Partitions", list),
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