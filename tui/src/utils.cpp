#include "headers/utils.h"

void draw_options(lpstf options, int selected) {
  erase();
  draw_border();
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
      if (selected == options.size()-1) break;
      options[selected].second();
    }
  } while(c != '1');
}

// Draws the main border around the terminal
void draw_border() {
  clear();
  box(stdscr, '*', '*');
}