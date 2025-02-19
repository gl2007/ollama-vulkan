cmake_minimum_required(VERSION 3.30.4)
set(CMAKE_MODULE_PATH "")
project(CheckHIP HIP)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/result.cmake"
  "set(CMAKE_HIP_COMPILER \"${CMAKE_HIP_COMPILER}\")\n"
  "set(CMAKE_HIP_PLATFORM \"${CMAKE_HIP_PLATFORM}\")\n"
  )