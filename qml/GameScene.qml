import Felgo
import QtQuick

import "game"
import "hud"
import "input"

Scene {
    id: gameScene

    signal exitRequested()

    width: 480
    height: 320

    Keys.onEscapePressed: gameScene.exitRequested()
    onBackButtonPressed: gameScene.exitRequested()
    onVisibleChanged: {
        if (gameScene.visible)
            internal.resetWorld()
    }

    Rectangle {
        anchors.fill: gameScene.fullWindowAnchorItem
        color: "#0a0e1a"
    }

    Item {
        id: world

        x: gameScene.width / 2 - internal.heroX
        y: gameScene.height / 2 - internal.heroY

        GroundLayer {
            heroX: internal.heroX
            heroY: internal.heroY
            viewWidth: gameScene.gameWindowAnchorItem.width
            viewHeight: gameScene.gameWindowAnchorItem.height
        }

        Item {
            z: 1

            DirectionalSprite {
                id: heroSprite

                x: internal.heroX - width / 2
                y: internal.heroY - height / 2
                z: internal.heroY
                entityKind: "hero"
                octant: internal.facingOctant
                animationName: internal.heroAnimationName
                running: gameScene.visible
            }

            EnemyActor {
                id: bandit

                targetX: internal.heroX
                targetY: internal.heroY
                initialX: 180
                initialY: 0
                entityKind: "bandit"
                moveSpeed: 55
                contactDistance: 27
                maxHp: 30
                attackDamage: 10
                attackInterval: 0.9
                running: gameScene.visible && internal.alive
                onDamageRequested: damage => internal.applyDamage(damage)
            }
        }
    }

    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        text: qsTr("Position: %1, %2")
                .arg(Math.round(internal.heroX))
                .arg(Math.round(internal.heroY))
        color: "#8d99ae"
        font.pixelSize: 11
    }

    FrameAnimation {
        running: gameScene.visible && !internal.gameOverVisible
        onTriggered: internal.advance(frameTime)
    }

    InputController {
        anchors.fill: gameScene.gameWindowAnchorItem
        inputEnabled: gameScene.visible && internal.alive
        onMoveRequested: (x, y) => internal.setMovement(x, y)
        onSprintRequested: sprinting => internal.setSprint(sprinting)
    }

    GameHud {
        anchors.fill: gameScene.gameWindowAnchorItem
        touchTargetSize: gameScene.dp(48)
        hp: internal.hp
        maxHp: internal.maxHp
        mana: 30
        stamina: internal.stamina
        maxStamina: internal.maxStamina
        kills: internal.kills
        onExitRequested: gameScene.exitRequested()
    }

    GameOverDialog {
        anchors.fill: gameScene.gameWindowAnchorItem
        z: 10
        opened: internal.gameOverVisible
        kills: internal.kills
        touchTargetSize: gameScene.dp(48)
        onRestartRequested: internal.resetWorld()
        onExitRequested: gameScene.exitRequested()
    }

    QtObject {
        id: internal

        readonly property real walkingSpeed: 120
        readonly property real sprintingSpeed: 185
        readonly property real maxStamina: 100
        readonly property real staminaDrainRate: 30
        readonly property real staminaRecoveryRate: 18
        readonly property real sprintRecoveryThreshold: 20
        readonly property real maxHp: 100
        readonly property real heroDamage: 12
        readonly property real heroAttackRate: 1.4
        readonly property real heroAttackRange: 78
        readonly property real attackAnimationDuration: 0.35
        readonly property real enemyRespawnDelay: 1.25
        readonly property real enemySpawnDistance: 180

        property real heroX: 0
        property real heroY: 0
        property real moveX: 0
        property real moveY: 0
        property real stamina: internal.maxStamina
        property real hp: internal.maxHp
        property bool sprintHeld: false
        property bool sprintExhausted: false
        property int facingOctant: 2
        property real attackCooldown: 0
        property real attackAnimationTime: 0
        property real enemyRespawnTime: 0
        property int nextSpawnOctant: 1
        property real deathAnimationTime: 0
        property bool gameOverVisible: false
        property int kills: 0

        readonly property bool alive: internal.hp > 0
        readonly property bool moving: internal.alive
                                       && (internal.moveX !== 0
                                           || internal.moveY !== 0)
        readonly property bool sprinting: internal.moving
                                            && internal.sprintHeld
                                            && internal.stamina > 0
                                            && !internal.sprintExhausted
        readonly property bool attacking: internal.alive
                                          && internal.attackAnimationTime > 0
        readonly property string heroAnimationName: !internal.alive ? "die"
                                                      : internal.attacking ? "attack"
                                                      : internal.sprinting ? "run"
                                                      : internal.moving ? "walk"
                                                                        : "idle"

        function resetWorld(): void {
            internal.heroX = 0
            internal.heroY = 0
            internal.moveX = 0
            internal.moveY = 0
            internal.stamina = internal.maxStamina
            internal.hp = internal.maxHp
            internal.sprintHeld = false
            internal.sprintExhausted = false
            internal.facingOctant = 2
            internal.attackCooldown = 0
            internal.attackAnimationTime = 0
            internal.enemyRespawnTime = 0
            internal.nextSpawnOctant = 1
            internal.deathAnimationTime = 0
            internal.gameOverVisible = false
            internal.kills = 0
            bandit.reset()
        }

        function setMovement(x: real, y: real): void {
            if (!internal.alive)
                return

            internal.moveX = x
            internal.moveY = y

            if ((x !== 0 || y !== 0) && !internal.attacking)
                internal.facingOctant = internal.octantFromDirection(x, y)
        }

        function setSprint(sprinting: bool): void {
            if (!internal.alive)
                return

            internal.sprintHeld = sprinting
        }

        function applyDamage(damage: real): void {
            if (!internal.alive || damage <= 0)
                return

            internal.hp = Math.max(0, internal.hp - damage)
            if (!internal.alive)
                internal.beginHeroDeath()
        }

        function advance(frameTime: real): void {
            if (!internal.alive) {
                internal.updateHeroDeath(frameTime)
                return
            }

            const sprintingThisFrame = internal.sprinting
            internal.attackCooldown = Math.max(
                        0, internal.attackCooldown - frameTime)
            internal.attackAnimationTime = Math.max(
                        0, internal.attackAnimationTime - frameTime)
            internal.updateStamina(frameTime)

            if (internal.moving) {
                if (!internal.attacking)
                    internal.facingOctant = internal.octantFromDirection(
                                internal.moveX, internal.moveY)

                const speed = sprintingThisFrame ? internal.sprintingSpeed
                                                  : internal.walkingSpeed
                const distance = speed * frameTime
                internal.heroX += internal.moveX * distance
                internal.heroY += internal.moveY * distance
            }

            if (bandit.alive) {
                internal.tryAttackBandit()
                bandit.advance(frameTime)
            } else {
                internal.updateEnemyRespawn(frameTime)
            }
        }

        function tryAttackBandit(): void {
            if (!bandit.alive || internal.attackCooldown > 0)
                return

            const dx = bandit.worldX - internal.heroX
            const dy = bandit.worldY - internal.heroY
            const distance = Math.sqrt(dx * dx + dy * dy)
            if (distance > internal.heroAttackRange)
                return

            internal.facingOctant = internal.octantFromDirection(dx, dy)
            internal.attackAnimationTime = internal.attackAnimationDuration
            internal.attackCooldown = 1 / internal.heroAttackRate

            if (bandit.takeDamage(internal.heroDamage))
                internal.handleBanditDefeated()
        }

        function handleBanditDefeated(): void {
            internal.kills += 1
            internal.enemyRespawnTime = internal.enemyRespawnDelay
        }

        function updateEnemyRespawn(frameTime: real): void {
            internal.enemyRespawnTime = Math.max(
                        0, internal.enemyRespawnTime - frameTime)
            if (internal.enemyRespawnTime === 0)
                internal.spawnNextBandit()
        }

        function spawnNextBandit(): void {
            const angle = internal.nextSpawnOctant * Math.PI / 4
            const spawnX = internal.heroX
                    + Math.cos(angle) * internal.enemySpawnDistance
            const spawnY = internal.heroY
                    + Math.sin(angle) * internal.enemySpawnDistance

            bandit.spawnAt(spawnX, spawnY)
            internal.nextSpawnOctant = (internal.nextSpawnOctant + 1) % 8
        }

        function beginHeroDeath(): void {
            internal.moveX = 0
            internal.moveY = 0
            internal.sprintHeld = false
            internal.attackCooldown = 0
            internal.attackAnimationTime = 0
            internal.deathAnimationTime = heroSprite.animationDuration
            internal.gameOverVisible = internal.deathAnimationTime <= 0
        }

        function updateHeroDeath(frameTime: real): void {
            if (internal.gameOverVisible)
                return

            internal.deathAnimationTime = Math.max(
                        0, internal.deathAnimationTime - frameTime)
            if (internal.deathAnimationTime === 0)
                internal.gameOverVisible = true
        }

        function updateStamina(frameTime: real): void {
            if (internal.sprinting) {
                internal.stamina = Math.max(0, internal.stamina
                                                - internal.staminaDrainRate * frameTime)
                if (internal.stamina === 0)
                    internal.sprintExhausted = true
                return
            }

            internal.stamina = Math.min(internal.maxStamina,
                                        internal.stamina
                                        + internal.staminaRecoveryRate * frameTime)
            if (internal.stamina >= internal.sprintRecoveryThreshold)
                internal.sprintExhausted = false
        }

        function octantFromDirection(x: real, y: real): int {
            const sector = Math.round(Math.atan2(y, x) / (Math.PI / 4))
            return (sector % 8 + 8) % 8
        }
    }
}
