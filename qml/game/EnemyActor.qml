import QtQuick

Item {
    id: root

    required property real targetX
    required property real targetY
    required property real initialX
    required property real initialY
    required property string entityKind
    required property real moveSpeed
    required property real contactDistance

    property bool running: true
    property real worldX: root.initialX
    property real worldY: root.initialY
    property int facingOctant: 4

    readonly property bool moving: internal.distance > root.contactDistance

    x: root.worldX - width / 2
    y: root.worldY - height / 2
    z: root.worldY
    implicitWidth: sprite.implicitWidth
    implicitHeight: sprite.implicitHeight

    function reset(): void {
        root.worldX = root.initialX
        root.worldY = root.initialY
        root.facingOctant = internal.octantFromDirection(
                    root.targetX - root.worldX,
                    root.targetY - root.worldY,
                    4)
    }

    function advance(frameTime: real): void {
        if (!root.running)
            return

        const dx = root.targetX - root.worldX
        const dy = root.targetY - root.worldY
        const distance = Math.sqrt(dx * dx + dy * dy)

        root.facingOctant = internal.octantFromDirection(
                    dx, dy, root.facingOctant)

        if (distance <= root.contactDistance || distance === 0)
            return

        const travelDistance = Math.min(root.moveSpeed * frameTime,
                                        distance - root.contactDistance)
        root.worldX += dx / distance * travelDistance
        root.worldY += dy / distance * travelDistance
    }

    DirectionalSprite {
        id: sprite

        anchors.fill: parent
        entityKind: root.entityKind
        octant: root.facingOctant
        animationName: root.moving ? "walk" : "idle"
        running: root.running
    }

    QtObject {
        id: internal

        readonly property real dx: root.targetX - root.worldX
        readonly property real dy: root.targetY - root.worldY
        readonly property real distance: Math.sqrt(internal.dx * internal.dx
                                                   + internal.dy * internal.dy)

        function octantFromDirection(x: real, y: real, fallback: int): int {
            if (x === 0 && y === 0)
                return fallback

            const sector = Math.round(Math.atan2(y, x) / (Math.PI / 4))
            return (sector % 8 + 8) % 8
        }
    }
}
