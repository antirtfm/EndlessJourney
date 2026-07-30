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
    required property real maxHp

    property bool running: true
    property real worldX: root.initialX
    property real worldY: root.initialY
    property real hp: root.maxHp
    property int facingOctant: 4

    readonly property bool alive: root.hp > 0
    readonly property real hpRatio: root.maxHp > 0 ? root.hp / root.maxHp : 0
    readonly property bool moving: root.alive
                                   && internal.distance > root.contactDistance

    visible: root.alive
    x: root.worldX - width / 2
    y: root.worldY - height / 2
    z: root.worldY
    implicitWidth: sprite.implicitWidth
    implicitHeight: sprite.implicitHeight

    function reset(): void {
        root.worldX = root.initialX
        root.worldY = root.initialY
        root.hp = root.maxHp
        root.facingOctant = internal.octantFromDirection(
                    root.targetX - root.worldX,
                    root.targetY - root.worldY,
                    4)
    }

    function takeDamage(damage: real): bool {
        if (!root.alive || damage <= 0)
            return false

        root.hp = Math.max(0, root.hp - damage)
        return !root.alive
    }

    function advance(frameTime: real): void {
        if (!root.running || !root.alive)
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
        running: root.running && root.alive
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: -2
        width: 26
        height: 3
        radius: 1
        color: "#40000000"
        visible: root.alive && root.hp < root.maxHp

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, root.hpRatio))
            height: parent.height
            radius: parent.radius
            color: "#e63946"
        }
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
