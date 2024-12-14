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
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        contentHeight: parent.height
        contentWidth: parent.width
        anchors.fill: parent

        PageHeader {
            id: header
            title: qsTr("Color legend")
        }

        Item {
            id: header2
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                margins: Theme.horizontalPageMargin
            }
            height: headerlabel.height

            Label {
                id: headerlabel
                text: qsTr("Rain")
            }
            Label {
                text: qsTr("Snow")
                anchors.right: parent.right
                visible: settings.snow
            }
        }

        Row {
            id: content
            width: page.width - 2 * Theme.horizontalPageMargin
            height: page.height - 2 * Theme.horizontalPageMargin - header.height - header2.height
            anchors {
                top: header2.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: Theme.horizontalPageMargin
            }
            spacing: Theme.paddingMedium

            Item {
                id: bar
                width: Theme.horizontalPageMargin
                height: parent.height
                anchors.margins: Theme.horizontalPageMargin

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                }

                Loader {
                    id: loader
                     anchors.fill: parent
                     sourceComponent: settings.rainColorScheme === 1 ? s0
                                    : settings.rainColorScheme === 2 ? s1
                                    : settings.rainColorScheme === 3 ? s2
                                    : settings.rainColorScheme === 4 ? s3
                                    : settings.rainColorScheme === 6 ? s5
                                    : settings.rainColorScheme === 7 ? s6
                                    : settings.rainColorScheme === 8 ? s7
                                                                     : s0
                }

                Component { // Original
                    id: s0
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                 GradientStop { position: 0.0; color: "#dfdfdf" }
                                 GradientStop { position: 0.1; color: "#9bea8f" }
                                 GradientStop { position: 0.2; color: "#58ff42" }
                                 GradientStop { position: 0.3; color: "#47c278" }
                                 GradientStop { position: 0.4; color: "#4793f9" }
                                 GradientStop { position: 0.5; color: "#0c59ff" }
                                 GradientStop { position: 0.6; color: "#6153c1" }
                                 GradientStop { position: 0.7; color: "#ff93a3" }
                                 GradientStop { position: 0.8; color: "#ff3f35" }
                                 GradientStop { position: 0.9; color: "#c20511" }
                                 GradientStop { position: 1.0; color: "#ffeb0a" }
                             }
                    }
                }

                Component { // UNiversal Blue
                    id: s1
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                 GradientStop { position: 0.0; color: "#cec08796" }//rgba(206, 192, 135, 0.59) }
                                 GradientStop { position: 0.1; color: "#e2d49bc7" }//rgba(226, 212, 155, 0.78) }
                                 GradientStop { position: 0.101; color: "#8de" }
                                 GradientStop { position: 0.2; color: "#00a3e0" }
                                 GradientStop { position: 0.3; color: "#07a" }
                                 GradientStop { position: 0.4; color: "#058" }
                                 GradientStop { position: 0.5; color: "#004460" }
                                 GradientStop { position: 0.501; color: "#fe0" }
                                 GradientStop { position: 0.6; color: "#fa0" }
                                 GradientStop { position: 0.7; color: "#f70" }
                                 GradientStop { position: 0.701; color: "#f40" }
                                 GradientStop { position: 0.8; color: "#c10000" }
                                 GradientStop { position: 0.9; color: "#400" }
                                 GradientStop { position: 0.901; color: "#faf" }
                                 GradientStop { position: 1.0; color: "#f7f" }
                             }
                    }
                }

                Component { // TITAN
                    id: s2
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                 GradientStop { position: 0.0; color: "#087fdb" }
                                 GradientStop { position: 0.1; color: "#1c47e8" }
                                 GradientStop { position: 0.2; color: "#6e0dc6" }
                                 GradientStop { position: 0.3; color: "#c80f86" }
                                 GradientStop { position: 0.4; color: "#c06487" }
                                 GradientStop { position: 0.5; color: "#d2883b" }
                                 GradientStop { position: 0.6; color: "#fac431" }
                                 GradientStop { position: 0.7; color: "#fefb02" }
                                 GradientStop { position: 0.8; color: "#fe9a58" }
                                 GradientStop { position: 0.9; color: "#fe5f05" }
                                 GradientStop { position: 1.0; color: "#fd341c" }
                             }
                    }
                }

                Component { // The Weather Channel (TWC)
                    id: s3
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                 GradientStop { position: 0.0; color: "#63eb63" }
                                 GradientStop { position: 0.1; color: "#3dc63d" }
                                 GradientStop { position: 0.2; color: "#1f9e34" }
                                 GradientStop { position: 0.3; color: "#116719" }
                                 GradientStop { position: 0.48; color: "#023002" }
                                 GradientStop { position: 0.5; color: "#023002" }
                                 GradientStop { position: 0.51; color: "#ff0" }
                                 GradientStop { position: 0.6; color: "#ff7f00" }
                                 GradientStop { position: 0.7; color: "#e60000" }
                                 GradientStop { position: 0.8; color: "#cd0000" }
                                 GradientStop { position: 0.9; color: "#9b0000" }
                                 GradientStop { position: 1.0; color: "#820000" }
                             }
                    }
                }

                Component { // NEXRAD
                    id: s5
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                 GradientStop { position: 0.0; color: "#009cf7" }
                                 GradientStop { position: 0.1; color: "#0000f7" }
                                 GradientStop { position: 0.2; color: "lime" }
                                 GradientStop { position: 0.3; color: "#03b703" }
                                 GradientStop { position: 0.4; color: "#087305" }
                                 GradientStop { position: 0.5; color: "#ff0" }
                                 GradientStop { position: 0.6; color: "#ecce00" }
                                 GradientStop { position: 0.7; color: "#fe9300" }
                                 GradientStop { position: 0.8; color: "red" }
                                 GradientStop { position: 0.9; color: "#bd0000" }
                                 GradientStop { position: 1.0; color: "#bd0000" }
                             }
                    }
                }

                Component { // Rainbow
                    id: s6
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                 GradientStop { position: 0.0; color: "#009f9f" }
                                 GradientStop { position: 0.1; color: "#008c4b" }
                                 GradientStop { position: 0.2; color: "#00d319" }
                                 GradientStop { position: 0.3; color: "#21fd22" }
                                 GradientStop { position: 0.4; color: "#fffd1b" }
                                 GradientStop { position: 0.5; color: "#ffd400" }
                                 GradientStop { position: 0.6; color: "#ffab00" }
                                 GradientStop { position: 0.7; color: "#ff6e00" }
                                 GradientStop { position: 0.8; color: "#f01002" }
                                 GradientStop { position: 0.9; color: "#d00523" }
                                 GradientStop { position: 1.0; color: "#e400b1" }
                             }
                    }
                }

                Component { // Dark Sky
                    id: s7
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                 GradientStop { position: 0.0; color: "#00000000" }// rgba(0, 0, 0, 0) }
                                 GradientStop { position: 0.2; color: "#005eb699" }//rgba(0, 94, 182, 0.6) }
                                 GradientStop { position: 0.3; color: "#2458afde" }//rgba(36, 88, 175, 0.87) }
                                 GradientStop { position: 0.4; color: "#8e4b9b" }
                                 GradientStop { position: 0.5; color: "#fc5370" }
                                 GradientStop { position: 0.6; color: "#ffb76e" }
                                 GradientStop { position: 0.7; color: "#fffd05" }
                                 GradientStop { position: 1.0; color: "#fffd05" }
                             }
                    }
                }
            }

            ColumnLayout {
                height: parent.height
                width: (parent.width - parent.spacing) / 2 - bar.width - parent.spacing

                Label {
                    text: qsTr("Overcast")
                }
                Label {
                    text: qsTr("Drizzle")
                }
                Label {
                    text: qsTr("Light rain")
                }
                Label {
                    text: qsTr("Moderate rain")
                }
                Label {
                    text: qsTr("Shower")
                }
                Label {
                    text: qsTr("Hail")
                }
            }

            ColumnLayout {
                height: parent.height
                width: (parent.width - parent.spacing) / 2 - bar.width - parent.spacing
                visible: settings.snow

                Label {
                    text: qsTr("Light")
                    anchors.right: parent.right
                }
                Label {
                    text: qsTr("Moderate")
                    anchors.right: parent.right
                }
                Label {
                    text: qsTr("Heavy")
                    anchors.right: parent.right
                }
            }

            Item {
                width: Theme.horizontalPageMargin
                height: parent.height
                anchors.margins: Theme.horizontalPageMargin
                visible: settings.snow

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                }

                Loader {
                    id: loadersnow
                     anchors.fill: parent
                     sourceComponent: settings.rainColorScheme === 1 ? snows0
                                    : settings.rainColorScheme === 2 ? snows1
                                    : settings.rainColorScheme === 3 ? snows2
                                    : settings.rainColorScheme === 4 ? snows1
                                    : settings.rainColorScheme === 6 ? snows5
                                    : settings.rainColorScheme === 7 ? snows1
                                    : settings.rainColorScheme === 8 ? snows1
                                                                     : snows0
                }

                Component { // Original
                    id: snows0
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                 GradientStop { position: 0.0; color: "#00000000" } //rgba(0, 0, 0, 0) 0%
                                 GradientStop { position: 0.0833; color: "#8fffff" }
                                 GradientStop { position: 0.1667; color: "#7fefff" }
                                 GradientStop { position: 0.25; color: "#6fdfff" }
                                 GradientStop { position: 0.3333; color: "#5fcfff" }
                                 GradientStop { position: 0.4167; color: "#4fafff" }
                                 GradientStop { position: 0.5; color: "#3f9fff" }
                                 GradientStop { position: 0.5833; color: "#2f8fff" }
                                 GradientStop { position: 0.6667; color: "#1f7fff" }
                                 GradientStop { position: 0.75; color: "#0f6fff" }
                                 GradientStop { position: 0.8333; color: "#005fff" }
                                 GradientStop { position: 0.9167; color: "#004fff" }
                                 GradientStop { position: 0.9999; color: "#003fff" }
                                 GradientStop { position: 1.0; color: "#000fff" }
                             }
                    }
                }

                Component { // UNiversal Blue, The Weather Channel (TWC), Rainbow, Dark Sky
                    id: snows1
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                GradientStop { position: 0.0; color: "#00000000" } //rgba(0, 0, 0, 0) 0%
                                GradientStop { position: 0.0909; color: "#9fdfff" }
                                GradientStop { position: 0.1818; color: "#7fbfff" }
                                GradientStop { position: 0.2727; color: "#5f9fff" }
                                GradientStop { position: 0.3636; color: "#4f8fff" }
                                GradientStop { position: 0.4545; color: "#3f7fff" }
                                GradientStop { position: 0.5455; color: "#2f6fff" }
                                GradientStop { position: 0.6364; color: "#1f5fff" }
                                GradientStop { position: 0.7273; color: "#0f4fff" }
                                GradientStop { position: 0.8182; color: "#003fff" }
                                GradientStop { position: 0.9091; color: "#002fff" }
                                GradientStop { position: 1.0; color: "#001fff" }
                            }
                    }
                }

                Component { // TITAN
                    id: snows2
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                GradientStop { position: 0.0; color: "#2fcfcf" }
                                GradientStop { position: 0.0909; color: "#9fdfff" }
                                GradientStop { position: 0.1818; color: "#7fbfff" }
                                GradientStop { position: 0.2727; color: "#5f9fff" }
                                GradientStop { position: 0.3636; color: "#4f8fff" }
                                GradientStop { position: 0.4545; color: "#3f7fff" }
                                GradientStop { position: 0.5455; color: "#2f6fff" }
                                GradientStop { position: 0.6364; color: "#1f5fff" }
                                GradientStop { position: 0.7273; color: "#0f4fff" }
                                GradientStop { position: 0.8182; color: "#003fff" }
                                GradientStop { position: 0.9091; color: "#002fff" }
                                GradientStop { position: 1.0; color: "#001fff" }
                            }
                    }
                }

                Component { // NEXRAD
                    id: snows5
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient:
                            Gradient {
                                GradientStop { position: 0.0; color: "#e5fefe" }
                                GradientStop { position: 0.0833; color: "#a3f3ff" }
                                GradientStop { position: 0.1667; color: "#51cffd" }
                                GradientStop { position: 0.25; color: "#0d99fc" }
                                GradientStop { position: 0.3333; color: "#0f75fb" }
                                GradientStop { position: 0.4167; color: "#1053fb" }
                                GradientStop { position: 0.50; color: "#103ffb" }
                                GradientStop { position: 0.5833; color: "#0b32cf" }
                                GradientStop { position: 0.6667; color: "#0b32cf" }
                                GradientStop { position: 0.75; color: "#0726a4" }
                                GradientStop { position: 0.8333; color: "#0726a4" }
                                GradientStop { position: 0.9167; color: "#031875" }
                                GradientStop { position: 1.0; color: "#031875" }
                             }
                    }
                }

            }
        }
    }
}
