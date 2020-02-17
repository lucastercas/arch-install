#include "headers/pkg_install.h"
#include "headers/init_screen.h"

#include <ncurses.h>
#include <signal.h>

// void* resize_handler(int sig) {
//   int nh, nw;
//   getmaxyx(stdscr, nh, nw);  /* get the new screen size */
//   return 1;
// }

void init_options() {
  initscr();
  cbreak(); // Disable buffering on input
  noecho(); // Suppers auto echoing of input
  nodelay(stdscr, TRUE);
  keypad(stdscr, TRUE); // Special keys
  // signal(SIGWINCH, resize_handler);
}

void init_colors() {
  start_color();
  init_pair(1, COLOR_BLACK, COLOR_BLUE);
  init_pair(2, COLOR_BLACK, COLOR_RED);
  init_pair(3, COLOR_RED, COLOR_WHITE);
}

WINDOW* create_window(int lines, int cols, int y0, int x0) {
  WINDOW* newWin =  newwin(lines, cols, y0, x0);
  box(newWin, '*', '*');
  return newWin;
}

int main() {
  init_options();
  init_colors();

  draw_border();

  int height, width;
  getmaxyx(stdscr, height, width);

  // std::string greetings = "Welcome to Arch Installation\n";
  // mvwaddstr(stdscr, 1, (width/2)-greetings.size()/2, greetings.c_str());

  init_screen::draw_screen();
  
  endwin();
  return 0;
}