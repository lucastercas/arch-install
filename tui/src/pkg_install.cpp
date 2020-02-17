#include "headers/pkg_install.h"

std::vector<std::string> pkg_options() {
  std::vector<std::string> options = {
    "Base Packages",
    "Libre Office",
    "Image Manipulation",
    "Development"
  };

  return options;
}