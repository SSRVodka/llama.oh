#pragma once

#include <string>

extern "C" {
    int cli_main(int argc, char **argv);
    bool ping(std::string host, int port);
}
