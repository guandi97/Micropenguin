#include <QApplication>
#include <QHBoxLayout>

#include "hexspinbox.h"

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);
    HexSpinBox *troll = new HexSpinBox();
    troll->show();
    return app.exec();
}
