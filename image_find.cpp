#include <opencv2/opencv.hpp>


// to compile:
// clang++ -o image_find image_find.cpp `pkg-config --cflags --libs opencv4`

int main(int argc, char** argv) {
    if (argc != 3) return 1;

    cv::Mat screenshot = cv::imread(argv[1]);
    cv::Mat templateImg = cv::imread(argv[2]);

    if (screenshot.empty() || templateImg.empty()) return 1;

    cv::Mat result;
    cv::matchTemplate(screenshot, templateImg, result, cv::TM_CCOEFF_NORMED);
    double maxVal;
    cv::Point maxLoc;
    cv::minMaxLoc(result, nullptr, &maxVal, nullptr, &maxLoc);

    if (maxVal >= 0.8) {
        std::printf("%d,%d %d,%d\n", maxLoc.x, maxLoc.y, maxLoc.x + templateImg.cols, maxLoc.y + templateImg.rows);
        return 0;
    } else {
        return 1;
    }
}
