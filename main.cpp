#include <QApplication>
#include "qmlapplicationviewer.h"
#include <QGraphicsObject>
#include <QGLWidget>
#include <QUrl>
#include <QDesktopWidget>
#include <QMainWindow>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    app->setGraphicsSystem("opengl");

    QmlApplicationViewer viewer;
    QGLFormat fmt;
    fmt.setSampleBuffers(false);
    QGLWidget* glWidget = new QGLWidget(fmt);

    viewer.setViewport(glWidget);

    //viewer.setWindowFlags(Qt::FramelessWindowHint);
    //viewer.setAttribute(Qt::WA_TranslucentBackground);
//    /viewer.viewport()->setAutoFillBackground(false);

  //  viewer.setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
    viewer.setMainQmlFile(QApplication::applicationDirPath() + "/../qml/FolderListTest/main.qml");

    //viewer.setWindowState(Qt::WindowMaximized);
    viewer.resize(qApp->desktop()->screenGeometry().width(), 3*qApp->desktop()->screenGeometry().height()/5);
    viewer.move(0, qApp->desktop()->screenGeometry().height()/2 - viewer.height()/2);

    if(argc>1)
    {
        QGraphicsObject * param = viewer.rootObject();
        QString s = QString::fromUtf8(argv[1]);
        s.remove("\"");
        QString url = QUrl::fromLocalFile(s).toString();
        param->setProperty("appParam", url);
        qDebug(url.toAscii().data());
    }

    viewer.showExpanded();

    return app->exec();
}
