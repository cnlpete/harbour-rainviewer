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
import Nemo.Configuration 1.0
import "pages"
import "components"

ApplicationWindow {
    id: root

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-rainviewer"
        synchronous: true

        property string mapboxApiKey
        property string mapstyle: "http://localhost:8553/v1/mbgl/style?style=osmbright"
        property int tileSize: 256
        property bool immediateSlider: true
        property bool antialiasing: true
        property int rainColorScheme: 2
        property bool useGps: true
        property bool followGps: true
    }

    Constants {
        id: constant
    }

    initialPage: Component { StartPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")


}
