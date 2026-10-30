#pragma once
#include <QObject>
#include <QProcess>
#include <QDesktopServices>
#include <QUrl>
#include <QStringList>

class AppLauncher : public QObject
{
    Q_OBJECT
public:
    using QObject::QObject;

    Q_INVOKABLE bool launch(const QString &command)
    {
        const QStringList parts = QProcess::splitCommand(command);
        if (parts.isEmpty())
            return false;
        const QString program = parts.first();
        const QStringList args = parts.mid(1);
        return QProcess::startDetached(program, args);
    }

    Q_INVOKABLE bool openUrl(const QString &url)
    {
        return QDesktopServices::openUrl(QUrl(url));
    }
};