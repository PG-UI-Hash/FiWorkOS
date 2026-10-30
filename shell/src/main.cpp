#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qqml.h>
#include "AppLauncher.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName("PrathamOS Shell");
    QGuiApplication::setOrganizationName("Pratham");

    qmlRegisterType<AppLauncher>("Pratham", 1, 0, "AppLauncher");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return 1;

    return app.exec();
}
