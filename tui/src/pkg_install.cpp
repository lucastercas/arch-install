#include "headers/pkg_install.h"

std::list<std::string> pkg_options() {
  std::list<std::string> options = {
    "Base Packages",
    "Libre Office",
    "Image Manipulation",
    "Development"
  };

  return options;
}