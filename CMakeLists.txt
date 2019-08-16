cmake_minimum_required (VERSION 2.8.4)
project (shard_rocks)
message(${CMAKE_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")


# find library
find_package(RocksDB REQUIRED)
find_package(DPDK REQUIRED)

add_subdirectory(client)
add_subdirectory(server)
