cmake_minimum_required(VERSION 3.21)
project(pratham-shell VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Gui Qml)

qt_add_executable(pratham-shell
    src/main.cpp
    src/AppLauncher.h
)

qt_add_resources(pratham-shell "qml"
    PREFIX "/"
    FILES
        qml/Main.qml
        qml/Launcher.qml
        qml/Panel.qml
        qml/Pds.qml
)

target_link_libraries(pratham-shell PRIVATE
    Qt6::Quick
    Qt6::Gui
    Qt6::Qml
)

install(TARGETS pratham-shell RUNTIME DESTINATION bin)