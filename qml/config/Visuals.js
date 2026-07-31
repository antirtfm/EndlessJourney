.pragma library

// Sprite sheet direction suffixes use a different order than the world octants.
// World octants start at east and rotate clockwise in screen coordinates.
var directionMap = [6, 7, 8, 1, 2, 3, 4, 5];

var configs = {
    hero: {
        frameSize: 256,
        renderSize: 60,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "hero/Idle/Knight_Idle_dir{dir}.png",
                frameCount: 17,
                fps: 7
            },
            walk: {
                pattern: "hero/Walk/Knight_Walk_dir{dir}.png",
                frameCount: 11,
                fps: 10
            },
            run: {
                pattern: "hero/Run/Knight_Run_dir{dir}.png",
                frameCount: 8,
                fps: 12
            },
            attack: {
                pattern: "hero/Attack/Knight_Attack_dir{dir}.png",
                frameCount: 15,
                fps: 30
            },
            die: {
                pattern: "hero/Die/Knight_Die_dir{dir}.png",
                frameCount: 27,
                fps: 7,
                loop: false
            }
        }
    },
    bandit: {
        frameSize: 256,
        renderSize: 67,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/bandit/Idle/Bandit_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 6
            },
            walk: {
                pattern: "enemies/bandit/Walk/Bandit_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 12
            },
            attack: {
                pattern: "enemies/bandit/Attack/Bandit_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 15
            }
        }
    },
    goblin: {
        frameSize: 256,
        renderSize: 58,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/goblin/Idle/Goblin_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 7
            },
            walk: {
                pattern: "enemies/goblin/Walk/Goblin_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 14
            },
            attack: {
                pattern: "enemies/goblin/Attack/Goblin_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 15
            }
        }
    },
    wolf: {
        frameSize: 256,
        renderSize: 55,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/wolf/Idle/Wolf_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 6
            },
            walk: {
                pattern: "enemies/wolf/Walk/Wolf_Walk_dir{dir}.png",
                frameCount: 16,
                fps: 14
            },
            attack: {
                pattern: "enemies/wolf/Attack/Wolf_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 15
            }
        }
    }
};

function animationFor(config, animationName) {
    return config.animations[animationName] || config.animations.idle;
}
