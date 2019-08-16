# include header of library
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${ROCKSDB_INCLUDE_DIRS})
include_directories(${DPDK_INCLUDE_DIR})

# rocksdb flags
set (PLATFORM_LDFLAGS stdc++ pthread rt snappy gflags z bz2 lz4 zstd numa m)
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mssse3 -O3 -Wall -Wextra -Wno-unused-parameter -fPIC -g")

set (LIBS ${LIBS} ${ROCKSDB_LIBRARIES} ${DPDK_LIBRARIES} ${PLATFORM_LDFLAGS})
aux_source_directory (src SRCS) # include every file in src directory
message (STATUS "This is CMAKE_CXX_FLAGS " ${CMAKE_CXX_FLAGS})
message (STATUS "This is CMAKE_SOURCE_DIR " ${CMAKE_SOURCE_DIR})

add_executable(rocksdb_client ${SRCS})
target_link_libraries (rocksdb_client ${LIBS})
set_target_properties (rocksdb_client PROPERTIES COMPILE_FLAGS ${CMAKE_CXX_FLAGS})
