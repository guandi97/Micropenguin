#ifndef HEXSPINBOX_H
#define HEXSPINBOX_H


#include <QSpinBox>

class HexSpinBox : public QSpinBox
{
    Q_OBJECT
public:
    //HexSpinBox(QWidget *parent= 0);

    HexSpinBox(QWidget *parent = 0) : QSpinBox(parent)
    {
        setRange(0,255);
        //validator = new QRegExpValidator(QRegExp("[0-9A-Fa-f]{1,8}"));
    }


};


#endif // HEXSPINBOX_H
