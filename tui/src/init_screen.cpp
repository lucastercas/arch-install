#include "headers/init_screen.h"
#include "headers/utils.h"

lst init_options() {
  lst opts = {
    "Install Packages",
    "Configure User",
    "Configure Root",
    "Initialize Services"
  };
  return opts;
}

void draw_options(lst options, int selected) {

  int height, width;
  getmaxyx(stdscr, height, width);

  int counter = 0;
  for(std::string opt: options) {
    counter == selected ? attron(A_STANDOUT) : attroff(A_STANDOUT);
    mvwaddstr(stdscr, (height/3)+counter, width/3, opt.c_str());
    counter++;
  }
}

void draw_init_screen() {
  std::list<std::string> opts = init_options();
  draw_options(opts, 0);

}

