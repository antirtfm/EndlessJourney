#include <QApplication>
#include <QCoreApplication>
#include <FelgoApplication>
#ifdef USE_FELGO_HOT_RELOAD
#include <FelgoHotReload>
#endif

#include <QQmlApplicationEngine>
#include <QtQml/qqml.h>

#include "src/entitymodel.h"
#include "src/gameengine.h"
#include "src/gamestatemachine.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    FelgoApplication felgo;

    // Use Felgo's default font instead of platform-specific fonts
    felgo.setPreservePlatformFonts(false);

    QQmlApplicationEngine engine;
    felgo.initialize(&engine);

    // Felgo initialization prepares the QML type registry, so custom backend
    // types must be registered afterwards and before Hot Reload loads QML.
    constexpr auto backendUri = "EndlessJourney.Backend";
    qmlRegisterAnonymousType<EntityModel>(backendUri, 1);
    qmlRegisterType<GameEngine>(backendUri, 1, 0, "GameEngine");
    qmlRegisterUncreatableMetaObject(
        GameState::staticMetaObject,
        backendUri,
        1,
        0,
        "GameState",
        QStringLiteral("GameState only provides enum values"));

    // Set an optional license key from project file
    // This does not work if using Felgo Developer App, only for Felgo Cloud Builds and local builds
    felgo.setLicenseKey(PRODUCT_LICENSE_KEY);

#ifdef USE_FELGO_HOT_RELOAD
    // Hot Reload loads Main.qml received from the local Felgo server.
    FelgoHotReload felgoHotReload(&engine);
#else
    // Normal builds load the QML module embedded by qt_add_qml_module().
    felgo.setMainQmlFileName(QStringLiteral("qml/Main.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
#endif

    return app.exec();
}
