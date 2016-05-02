include(ExternalProject)
find_package(Git REQUIRED)

ExternalProject_Add(
        bandit_sources
        PREFIX ${CMAKE_BINARY_DIR}/lib/bandit
        GIT_REPOSITORY https://github.com/joakimkarlsson/bandit.git
        GIT_TAG 7b282209fb1cd9bfa36472feee453b35454e57c0
        TIMEOUT 10
        UPDATE_COMMAND ${GIT_EXECUTABLE} pull
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        LOG_DOWNLOAD ON
)

ExternalProject_Get_Property(bandit_sources source_dir)

add_library(bandit INTERFACE)
add_dependencies(bandit bandit_sources)
target_include_directories(bandit INTERFACE ${source_dir}/)
