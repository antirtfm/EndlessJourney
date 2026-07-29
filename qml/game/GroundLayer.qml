pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root

    required property real heroX
    required property real heroY
    required property real viewWidth
    required property real viewHeight

    Repeater {
        model: internal.columns * internal.rows

        delegate: Rectangle {
            id: tile

            required property int index

            readonly property int column: internal.originColumn + tile.index % internal.columns
            readonly property int row: internal.originRow + Math.floor(tile.index / internal.columns)
            readonly property real shade: internal.cellShade(tile.column, tile.row)

            x: tile.column * internal.tileSize
            y: tile.row * internal.tileSize
            width: internal.tileSize + 1 // +1 avoids hairline seams between tiles
            height: internal.tileSize + 1
            color: Qt.hsla(0.34 - tile.shade * 0.03,
                           0.25,
                           0.075 + tile.shade * 0.035,
                           1)
        }
    }

    QtObject {
        id: internal

        readonly property int tileSize: 48
        readonly property int columns: Math.ceil(root.viewWidth * 2 / internal.tileSize) + 1
        readonly property int rows: Math.ceil(root.viewHeight * 2 / internal.tileSize) + 1
        readonly property int originColumn: Math.floor(root.heroX / internal.tileSize)
                                            - Math.floor(internal.columns / 2)
        readonly property int originRow: Math.floor(root.heroY / internal.tileSize)
                                         - Math.floor(internal.rows / 2)

        function cellShade(column: int, row: int): real {
            const seed = Math.imul(column, 73856093) ^ Math.imul(row, 19349663)
            const mixed = Math.imul(seed ^ (seed >> 13), 1274126177)
            const unsignedValue = (mixed ^ (mixed >> 16)) >>> 0
            return (unsignedValue % 1000) / 1000
        }
    }
}
