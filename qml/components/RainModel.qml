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
import "NetworkCall.js" as NetworkCall

ListModel {
    id: root

    property int generated: 0
    property string host: "https://tilecache.rainviewer.com"
    property int mostCurrentIndex: -1

    function reload() {
        model.clear()
        model.mostCurrentIndex = -1

        NetworkCall.networkCall("https://api.rainviewer.com/public/weather-maps.json", handleData)
    }

    function handleData(data) {
        root.host = data.host || root.host
        root.generated = data.generated

        for (var i = 0; i < data.radar.past.length; i++) {
            const pastItem = data.radar.past[i]
            model.append({
                             path: data.host + "/" + pastItem.path,
                             time: pastItem.time
                         })
            //console.log("appending to model: ", pastItem)
        }
        model.mostCurrentIndex = data.radar.past.length - 1

        for (i = 0; i < data.radar.nowcast.length; i++) {
            const nowcastItem = data.radar.nowcast[i]
            model.append({
                             path: data.host + "/" + nowcastItem.path,
                             time: nowcastItem.time
                         })
            //console.log("appending to model: ", nowcastItem)
        }
        console.log("model size is now ", model.count)
    }
}
