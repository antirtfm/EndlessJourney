#include <QApplication>
#include <FelgoApplication>
#ifdef USE_FELGO_HOT_RELOAD
#include <FelgoHotReload>
#endif

#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    FelgoApplication felgo;

    // Use Felgo's default font instead of platform-specific fonts
    felgo.setPreservePlatformFonts(false);

    QQmlApplicationEngine engine;
    felgo.initialize(&engine);

    // Set an optional license key from project file
    // This does not work if using Felgo Developer App, only for Felgo Cloud Builds and local builds
    felgo.setLicenseKey(PRODUCT_LICENSE_KEY);

#ifdef USE_FELGO_HOT_RELOAD
    // Hot Reload loads Main.qml received from the local Felgo server.
    FelgoHotReload felgoHotReload(&engine);
#else
    // Normal builds load the QML source deployed beside the executable.
    felgo.setMainQmlFileName(QStringLiteral("qml/Main.qml"));
    engine.load(QUrl(felgo.mainQmlFileName()));
#endif

    return app.exec();
}
