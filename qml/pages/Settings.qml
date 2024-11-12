/*
 * This file is part of harbour-rainviewer.
 * Copyright (C) 2024 <cnlpete.de> Hauke Schade
 *
 * harbour-rainviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * harbour-rainviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with harbour-rainviewer.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: settingsPage
    allowedOrientations: Orientation.PortraitMask

    SilicaFlickable {
        contentHeight: settingsColumn.height
        contentWidth: parent.width
        anchors.fill: parent

        /*PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("About.qml"));
                }
            }
        }*/

        Column {
            id: settingsColumn
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.horizontalPageMargin
            }
            spacing: Theme.paddingMedium

            DialogHeader {
                width: dialog.width
                title: qsTr("Settings")
                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
            }


            SectionHeader {
                text: qsTr("Map settings")
            }

            ComboBox {
                id: mapstyleSetting
                label: qsTr("Map style")
                currentIndex: 0
                description: qsTr('You need to restart the App for this to take effect.')

                menu: ContextMenu {
                    MenuItem {
                        text: "Osmscout Server"
                        property string url: "http://localhost:8553/v1/mbgl/style?style=osmbright"
                        Component.onCompleted: if (url === settings.mapstyle) mapstyleSetting.currentIndex = 0
                    }
                    MenuItem {
                        text: "OpenFreeMap Bright"
                        property string url: "https://tiles.openfreemap.org/styles/bright"
                        Component.onCompleted: if (url === settings.mapstyle) mapstyleSetting.currentIndex = 1
                    }

                    /*MenuItem {
                        text: qsTr("Mapbox Streets (req. API Key)")
                        property string url: "mapbox://styles/mapbox/streets-v11"
                        Component.onCompleted: if (url === settings.mapstyle) mapstyleSetting.currentIndex = 2
                    }
                    MenuItem {
                        text: qsTr("Mapbox Outdoors (req. API Key)")
                        property string url: "mapbox://styles/mapbox/outdoors-v11"
                        Component.onCompleted: if (url === settings.mapstyle) mapstyleSetting.currentIndex = 3
                    }*/
                }
            }

            TextSwitch {
                id: gpsSetting
                text: qsTr('Enable GPS')
                description: qsTr('Will enable gps tracking while the application is visible')
                checked: settings.useGps
            }

            TextSwitch {
                id: gpsFollowSetting
                text: qsTr('Follow GPS')
                visible: gpsSetting.checked
                description: qsTr('Will make the view follow your gps position')
                checked: settings.followGps
            }

            SectionHeader {
                text: qsTr("Rain settings")
            }

            TextSwitch {
                id: antialiasingSetting
                text: qsTr('Smooth Rain Rendering')
                description: qsTr('You need to restart the App for this to take effect.')
                checked: settings.antialiasing
            }

            ComboBox {
                id: rainResolutionSetting
                label: qsTr("Rain resolution")
                description: qsTr('You need to restart the App for this to take effect.')
                currentIndex: settings.tileSize === 256 ? 0 : 1

                menu: ContextMenu {
                    MenuItem {
                        text: "256x256"
                        property int resolution: 256
                    }
                    MenuItem {
                        text: "512x512"
                        property int resolution: 512
                    }
                }
            }

            ComboBox {
                id: rainColorSetting
                label: qsTr("Rain color scheme")
                description: qsTr('You need to restart the App for this to take effect.')
                currentIndex: settings.rainColorScheme

                menu: ContextMenu {
                    MenuItem {
                        text: "BW Black and White: dBZ values"
                    }
                    MenuItem {
                        text: "Original"
                    }
                    MenuItem {
                        text: "Universal Blue"
                    }
                    MenuItem {
                        text: "TITAN"
                    }
                    MenuItem {
                        text: "The Weather Channel (TWC)"
                    }
                    MenuItem {
                        text: "Meteored"
                    }
                    MenuItem {
                        text: "NEXRAD Level III"
                    }
                    MenuItem {
                        text: "Rainbow @ SELEX-IS"
                    }
                    MenuItem {
                        text: "Dark Sky"
                    }
                }
            }
        }
        VerticalScrollDecorator {}
    }

    onAccepted: {

        //settings.mapboxApiKey // TODO
        settings.mapstyle = mapstyleSetting.currentItem.url
        settings.tileSize = rainResolutionSetting.currentItem.resolution
        settings.rainColorScheme = rainColorSetting.currentIndex
        //settings.immediateSlider = true // TODO
        settings.antialiasing = antialiasingSetting.checked

        settings.useGps = gpsSetting.checked
        if (gpsFollowSetting.visible) {
            settings.followGps = gpsFollowSetting.checked
        }
    }
}
