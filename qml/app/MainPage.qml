import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls.Material 2.0
import AsemanQml.MaterialIcons 2.0
import globals 1.0
import requests 1.0
import components 1.0
import "auth" as Auth
import "pages/timeline" as TimeLine
import "routes"

TPage {
    id: dis
    font.family: Fonts.globalFont

    IOSStyle.accent: Colors.accent
    IOSStyle.primary: Colors.primary

    Material.accent: Colors.accent
    Material.primary: Colors.primary

    property alias viewport: mainViewport
    readonly property bool mobileView: width < height || Devices.isMobile

    Component.onCompleted: {
        GlobalSettings.mobileView = Qt.binding(function(){ return dis.mobileView; });
    }

    Connections {
        target: GlobalSignals
        function onSnackRequest(text) {
            snackBar.open(text);
        }
        function onErrorRequest(text) {
            errorsSnackBar.open(text);
        }
    }

    Viewport {
        id: mainViewport
        anchors.fill: parent
        mainItem: TPage {
            anchors.fill: parent

            TLoader {
                anchors.fill: parent
                active: GlobalSettings.accessToken.length !== 0
                sourceComponent: Home {
                    anchors.fill: parent
                }
            }

            TLoader {
                anchors.fill: parent
                active: GlobalSettings.accessToken.length === 0 && (Bootstrap.timeline.unauth_timeline && GlobalSettings.mobileView)
                sourceComponent: TimeLine.NonAuthTimeLinePage {
                    anchors.fill: parent
                }
            }

            TLoader {
                anchors.fill: parent
                active: GlobalSettings.accessToken.length === 0 && (!Bootstrap.timeline.unauth_timeline || !GlobalSettings.mobileView)
                sourceComponent: Auth.AuthPage {
                    anchors.fill: parent
                }
            }
        }
    }

    Snackbar {
        id: snackBar
        z: 1000
    }

    Snackbar {
        id: errorsSnackBar
        z: 1000
        color: "#a00"
    }

    ViewController {
        id: mainController
        viewport: mainViewport
        Component.onCompleted: GlobalMethods.viewController = mainController
    }
}
