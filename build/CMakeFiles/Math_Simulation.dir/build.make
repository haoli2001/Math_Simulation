# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.29

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files\CMake\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files\CMake\bin\cmake.exe" -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = D:\705\Math_Simulation

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = D:\705\Math_Simulation\build

# Include any dependencies generated for this target.
include CMakeFiles/Math_Simulation.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/Math_Simulation.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/Math_Simulation.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Math_Simulation.dir/flags.make

CMakeFiles/Math_Simulation.dir/main.cpp.obj: CMakeFiles/Math_Simulation.dir/flags.make
CMakeFiles/Math_Simulation.dir/main.cpp.obj: CMakeFiles/Math_Simulation.dir/includes_CXX.rsp
CMakeFiles/Math_Simulation.dir/main.cpp.obj: D:/705/Math_Simulation/main.cpp
CMakeFiles/Math_Simulation.dir/main.cpp.obj: CMakeFiles/Math_Simulation.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=D:\705\Math_Simulation\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/Math_Simulation.dir/main.cpp.obj"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/Math_Simulation.dir/main.cpp.obj -MF CMakeFiles\Math_Simulation.dir\main.cpp.obj.d -o CMakeFiles\Math_Simulation.dir\main.cpp.obj -c D:\705\Math_Simulation\main.cpp

CMakeFiles/Math_Simulation.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/Math_Simulation.dir/main.cpp.i"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E D:\705\Math_Simulation\main.cpp > CMakeFiles\Math_Simulation.dir\main.cpp.i

CMakeFiles/Math_Simulation.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/Math_Simulation.dir/main.cpp.s"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S D:\705\Math_Simulation\main.cpp -o CMakeFiles\Math_Simulation.dir\main.cpp.s

CMakeFiles/Math_Simulation.dir/getopt.cpp.obj: CMakeFiles/Math_Simulation.dir/flags.make
CMakeFiles/Math_Simulation.dir/getopt.cpp.obj: CMakeFiles/Math_Simulation.dir/includes_CXX.rsp
CMakeFiles/Math_Simulation.dir/getopt.cpp.obj: D:/705/Math_Simulation/getopt.cpp
CMakeFiles/Math_Simulation.dir/getopt.cpp.obj: CMakeFiles/Math_Simulation.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=D:\705\Math_Simulation\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/Math_Simulation.dir/getopt.cpp.obj"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/Math_Simulation.dir/getopt.cpp.obj -MF CMakeFiles\Math_Simulation.dir\getopt.cpp.obj.d -o CMakeFiles\Math_Simulation.dir\getopt.cpp.obj -c D:\705\Math_Simulation\getopt.cpp

CMakeFiles/Math_Simulation.dir/getopt.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/Math_Simulation.dir/getopt.cpp.i"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E D:\705\Math_Simulation\getopt.cpp > CMakeFiles\Math_Simulation.dir\getopt.cpp.i

CMakeFiles/Math_Simulation.dir/getopt.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/Math_Simulation.dir/getopt.cpp.s"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S D:\705\Math_Simulation\getopt.cpp -o CMakeFiles\Math_Simulation.dir\getopt.cpp.s

CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.obj: CMakeFiles/Math_Simulation.dir/flags.make
CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.obj: CMakeFiles/Math_Simulation.dir/includes_CXX.rsp
CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.obj: D:/705/Math_Simulation/mpi_manage.cpp
CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.obj: CMakeFiles/Math_Simulation.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=D:\705\Math_Simulation\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.obj"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.obj -MF CMakeFiles\Math_Simulation.dir\mpi_manage.cpp.obj.d -o CMakeFiles\Math_Simulation.dir\mpi_manage.cpp.obj -c D:\705\Math_Simulation\mpi_manage.cpp

CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.i"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E D:\705\Math_Simulation\mpi_manage.cpp > CMakeFiles\Math_Simulation.dir\mpi_manage.cpp.i

CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.s"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S D:\705\Math_Simulation\mpi_manage.cpp -o CMakeFiles\Math_Simulation.dir\mpi_manage.cpp.s

CMakeFiles/Math_Simulation.dir/sim_lib.cpp.obj: CMakeFiles/Math_Simulation.dir/flags.make
CMakeFiles/Math_Simulation.dir/sim_lib.cpp.obj: CMakeFiles/Math_Simulation.dir/includes_CXX.rsp
CMakeFiles/Math_Simulation.dir/sim_lib.cpp.obj: D:/705/Math_Simulation/sim_lib.cpp
CMakeFiles/Math_Simulation.dir/sim_lib.cpp.obj: CMakeFiles/Math_Simulation.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=D:\705\Math_Simulation\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/Math_Simulation.dir/sim_lib.cpp.obj"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/Math_Simulation.dir/sim_lib.cpp.obj -MF CMakeFiles\Math_Simulation.dir\sim_lib.cpp.obj.d -o CMakeFiles\Math_Simulation.dir\sim_lib.cpp.obj -c D:\705\Math_Simulation\sim_lib.cpp

CMakeFiles/Math_Simulation.dir/sim_lib.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/Math_Simulation.dir/sim_lib.cpp.i"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E D:\705\Math_Simulation\sim_lib.cpp > CMakeFiles\Math_Simulation.dir\sim_lib.cpp.i

CMakeFiles/Math_Simulation.dir/sim_lib.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/Math_Simulation.dir/sim_lib.cpp.s"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S D:\705\Math_Simulation\sim_lib.cpp -o CMakeFiles\Math_Simulation.dir\sim_lib.cpp.s

CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.obj: CMakeFiles/Math_Simulation.dir/flags.make
CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.obj: CMakeFiles/Math_Simulation.dir/includes_CXX.rsp
CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.obj: D:/705/Math_Simulation/socketFunctions.cpp
CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.obj: CMakeFiles/Math_Simulation.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=D:\705\Math_Simulation\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.obj"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.obj -MF CMakeFiles\Math_Simulation.dir\socketFunctions.cpp.obj.d -o CMakeFiles\Math_Simulation.dir\socketFunctions.cpp.obj -c D:\705\Math_Simulation\socketFunctions.cpp

CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.i"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E D:\705\Math_Simulation\socketFunctions.cpp > CMakeFiles\Math_Simulation.dir\socketFunctions.cpp.i

CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.s"
	D:\mingw\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S D:\705\Math_Simulation\socketFunctions.cpp -o CMakeFiles\Math_Simulation.dir\socketFunctions.cpp.s

# Object files for target Math_Simulation
Math_Simulation_OBJECTS = \
"CMakeFiles/Math_Simulation.dir/main.cpp.obj" \
"CMakeFiles/Math_Simulation.dir/getopt.cpp.obj" \
"CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.obj" \
"CMakeFiles/Math_Simulation.dir/sim_lib.cpp.obj" \
"CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.obj"

# External object files for target Math_Simulation
Math_Simulation_EXTERNAL_OBJECTS =

Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/main.cpp.obj
Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/getopt.cpp.obj
Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/mpi_manage.cpp.obj
Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/sim_lib.cpp.obj
Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/socketFunctions.cpp.obj
Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/build.make
Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/linkLibs.rsp
Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/objects1.rsp
Math_Simulation.exe: CMakeFiles/Math_Simulation.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=D:\705\Math_Simulation\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Linking CXX executable Math_Simulation.exe"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles\Math_Simulation.dir\link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Math_Simulation.dir/build: Math_Simulation.exe
.PHONY : CMakeFiles/Math_Simulation.dir/build

CMakeFiles/Math_Simulation.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles\Math_Simulation.dir\cmake_clean.cmake
.PHONY : CMakeFiles/Math_Simulation.dir/clean

CMakeFiles/Math_Simulation.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" D:\705\Math_Simulation D:\705\Math_Simulation D:\705\Math_Simulation\build D:\705\Math_Simulation\build D:\705\Math_Simulation\build\CMakeFiles\Math_Simulation.dir\DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/Math_Simulation.dir/depend
