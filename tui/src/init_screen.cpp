#include "headers/init_screen.h"
#include "headers/utils.h"

void test_func() {
  waddstr(stdscr, "iae");
}

lpstf init_options() {
  lpstf opts = {
    std::make_pair("Format Disks", &test_func),
    std::make_pair("Mount Disks", &test_func),
    std::make_pair("Pacstrap Partition", test_func),
    std::make_pair("Generate Fstab", test_func),
    std::make_pair("Arch Chroot Options", test_func)
  };
  return opts;
}

void draw_options(lpstf options, int selected) {

  int height, width;
  getmaxyx(stdscr, height, width);
  int c;
  do {
    int counter = 0;
    // Draw each option on screen
    for(const std::pair<const std::string, fType> opt: options) {
      // If the current option is the selected one, highlight it
      counter == selected ? attron(A_STANDOUT) : attroff(A_STANDOUT);
      mvwaddstr(stdscr, (height/3)+counter, width/3, opt.first.c_str());
      counter++;
    }

    c = getch();
    if (c == KEY_UP) selected == 0 ? : selected--;
    else if (c == KEY_DOWN) selected == options.size()-1 ? : selected++;
    else if (c == '\n') {
      options[selected].second();
    }
  } while(c != '1');
}

void draw_init_screen() {
  lpstf opts = init_options();
  draw_options(opts, 0);

}

