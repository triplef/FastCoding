cmake_minimum_required(VERSION 3.24)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64")
set(CMAKE_OSX_DEPLOYMENT_TARGET 10.14.4)

project(FastCodingTest)

if(WIN32 OR ANDROID)
	if(NOT DEFINED GNUSTEP_TOOLCHAIN_ROOT)
		message(FATAL_ERROR "GNUSTEP_TOOLCHAIN_ROOT environment variable is not set")
	endif()

	include(${GNUSTEP_TOOLCHAIN_ROOT}/objc.cmake)
endif()

add_executable(FastCodingTest)

target_include_directories(FastCodingTest PRIVATE
	../FastCoder
)

target_sources(FastCodingTest PRIVATE
	FastCodingTest.m
	../FastCoder/FastCoder.m
)

if(GNUSTEP)
	target_link_libraries(FastCodingTest PRIVATE GNUstep-Additions)
else()
	target_link_libraries(FastCodingTest
	    "-framework Foundation"
	)
endif()
