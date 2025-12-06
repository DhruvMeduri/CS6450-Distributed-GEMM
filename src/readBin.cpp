#include <iostream>
#include <fstream>
#include <vector>

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Usage: ./printbin <file.bin>\n";
        return 1;
    }

    const char* path = argv[1];
    std::ifstream in(path, std::ios::binary);

    if (!in) {
        std::cerr << "Error: cannot open file " << path << "\n";
        return 1;
    }

    // Read whole file
    in.seekg(0, std::ios::end);
    std::size_t size = in.tellg();
    in.seekg(0, std::ios::beg);

    if (size % sizeof(float) != 0) {
        std::cout << "Warning: file size is not divisible by sizeof(float)\n";
    }

    std::size_t count = size / sizeof(float);
    std::vector<float> data(count);

    in.read(reinterpret_cast<char*>(data.data()), size);

    // Print
    for (std::size_t i = 0; i < count; i++) {
        std::cout << data[i] << "\n";
    }

    return 0;
}

