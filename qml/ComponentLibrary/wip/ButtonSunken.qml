import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.impl
import QtQuick.Templates as T

import ThemeEngine
import "qrc:/utils/UtilsNumber.js" as UtilsNumber

T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            rowrowrow.width + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    leftPadding: 12
    rightPadding: 12
    spacing: 6

    // settings
    flat: true
    checkable: true
    focusPolicy: Qt.NoFocus
    font.pixelSize: Theme.componentFontSize
    font.bold: false

    // layout
    property int alignment: Qt.AlignCenter // Qt.AlignLeft // Qt.AlignRight
    property int layoutDirection: Qt.LeftToRight // Qt.RightToLeft

    // icon
    property url source
    property int sourceSize: UtilsNumber.alignTo(height * 0.5, 2)
    property int sourceRotation: 0

    // colors
    property color colorBackground: Theme.colorBackground
    property color colorHighlight: Theme.colorForeground
    property color colorRipple: Qt.darker(Theme.colorForeground, 1.1)
    property color colorText: Theme.colorText

    ////////////////

    background: Item {
        implicitWidth: 80
        implicitHeight: Theme.componentHeight

        Rectangle {
            anchors.fill: parent
            radius: Theme.componentRadius
            color: control.checked ? control.colorHighlight : control.colorBackground
        }
        Rectangle {
            anchors.fill: parent
            radius: Theme.componentRadius
            color: control.colorHighlight
            opacity: control.hovered ? 0.66 : 0
            Behavior on opacity { NumberAnimation { duration: 133 } }
        }

        RippleThemed {
            width: parent.width
            height: parent.height

            anchor: control
            pressed: control.pressed
            active: control.enabled && (control.down || control.visualFocus)
            color: Qt.rgba(control.colorRipple.r, control.colorRipple.g, control.colorRipple.b, 0.1)

            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskInverted: false
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
                maskSpreadAtMax: 0.0
                maskSource: ShaderEffectSource {
                    sourceItem: Rectangle {
                        x: background.x
                        y: background.y
                        width: background.width
                        height: background.height
                        radius: Theme.componentRadius
                    }
                }
            }
        }
    }

    ////////////////

    contentItem: Item {
        RowLayout {
            id: rowrowrow
            anchors.right: (control.alignment === Qt.AlignRight) ? parent.right : undefined
            anchors.horizontalCenter: (control.alignment === Qt.AlignCenter) ? parent.horizontalCenter : undefined
            anchors.verticalCenter: parent.verticalCenter

            spacing: control.spacing
            layoutDirection: {
                if (control.alignment === Qt.AlignRight) return Qt.RightToLeft
                return Qt.LeftToRight
            }

            IconSvg {
                Layout.maximumWidth: control.sourceSize
                Layout.maximumHeight: control.sourceSize
                Layout.alignment: Qt.AlignVCenter

                visible: control.source.toString().length
                color: control.colorText
                opacity: control.enabled ? 1 : 0.66
                rotation: control.sourceRotation

                source: control.source
            }

            Text {
                Layout.alignment: Qt.AlignVCenter

                color: control.colorText
                opacity: control.enabled ? 1 : 0.66

                visible: control.text
                text: control.text
                textFormat: Text.PlainText

                font: control.font
                elide: Text.ElideMiddle
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    ////////////////
}
