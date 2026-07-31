cmake_minimum_required(VERSION 3.16)

project(EndlessJourney VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Felgo REQUIRED)
find_package(FelgoHotReload REQUIRED)
qt_policy(SET QTP0004 NEW)

# Project identifier and version
# More information: https://felgo.com/doc/felgo-publishing/#project-configuration
set(PRODUCT_IDENTIFIER "com.yourcompany.EndlessJourney")
set(PRODUCT_VERSION_NAME "0.1")
set(PRODUCT_VERSION_CODE 1)

# Set either "test" or "publish" stage:
set(PRODUCT_STAGE "test")

# Optionally set a license key that is used instead of the license key from
# main.qml file (GameWindow::licenseKey for your game)
# Only used for local builds and Felgo Cloud Builds (https://felgo.com/cloud-builds)
# Not used if using Felgo Developer App
set(PRODUCT_LICENSE_KEY "")

# Keep source lists explicit so adding or removing a file always regenerates the
# correct deployment, QML compilation and lint rules.
set(QmlFiles
    qml/GameScene.qml
    qml/Main.qml
    qml/MainMenu.qml
    qml/components/GameActionButton.qml
    qml/config/Visuals.js
    qml/game/DirectionalSprite.qml
    qml/game/EntityView.qml
    qml/game/GroundLayer.qml
    qml/game/LevelUpFx.qml
    qml/game/WorldLayer.qml
    qml/hud/GameHud.qml
    qml/hud/GameOverDialog.qml
    qml/hud/HudBar.qml
    qml/input/InputController.qml
    qml/util/TimeFormatter.qml
)

set(Sources
    src/balance.h
    src/entity.h
    src/entitymodel.cpp
    src/entitymodel.h
    src/gameengine.cpp
    src/gameengine.h
    src/gamestatemachine.cpp
    src/gamestatemachine.h
    src/systems/combatsystem.cpp
    src/systems/enemybehaviorsystem.cpp
    src/systems/movementsystem.cpp
    src/systems/progressionsystem.cpp
    src/systems/simulationmath.h
    src/systems/spawnsystem.cpp
    src/systems/worldsystems.h
    src/world.cpp
    src/world.h
)

file(GLOB_RECURSE AssetFiles CONFIGURE_DEPENDS
    RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"
    "assets/*"
)

# Executable should have same name as project
qt_add_executable(appEndlessJourney
    main.cpp
    ${Sources}
)

felgo_configure_executable(appEndlessJourney)
felgohotreload_configure_executable(appEndlessJourney)

target_include_directories(appEndlessJourney PRIVATE src)

# Deploy resources to build folder/package directly
# comment for publishing
deploy_resources("${QmlFiles};${AssetFiles}")

# Add QML files and resources to QML module to include them via QRC automatically:
qt_add_qml_module(appEndlessJourney
    URI EndlessJourney
    QML_FILES ${QmlFiles}
    RESOURCES ${AssetFiles}
    NO_RESOURCE_TARGET_PATH
)

# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the deploy_resources line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the compiled QML files from the resources
# for more details see the "Deployment Guides" in the Felgo Documentation

target_compile_definitions(appEndlessJourney
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(appEndlessJourney PRIVATE Felgo)
