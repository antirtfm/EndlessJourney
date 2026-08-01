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
    slime: {
        frameSize: 256,
        renderSize: 53,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/slime/Idle/Slime_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 6
            },
            walk: {
                pattern: "enemies/slime/Walk/Slime_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 10
            },
            attack: {
                pattern: "enemies/slime/Attack/Slime_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 12
            }
        }
    },
    skeleton: {
        frameSize: 256,
        renderSize: 64,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/skeleton/Idle/Skeleton_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 6
            },
            walk: {
                pattern: "enemies/skeleton/Walk/Skeleton_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 12
            },
            attack: {
                pattern: "enemies/skeleton/Attack/Skeleton_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 14
            }
        }
    },
    orc: {
        frameSize: 256,
        renderSize: 83,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/orc/Idle/Orc_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 6
            },
            walk: {
                pattern: "enemies/orc/Walk/Orc_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 10
            },
            attack: {
                pattern: "enemies/orc/Attack/Orc_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 12
            }
        }
    },
    darkElf: {
        frameSize: 256,
        renderSize: 64,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/dark_elf/Idle/DarkElf_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 7
            },
            walk: {
                pattern: "enemies/dark_elf/Walk/DarkElf_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 14
            },
            attack: {
                pattern: "enemies/dark_elf/Attack/DarkElf_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 15
            }
        }
    },
    flyingDemon: {
        frameSize: 256,
        renderSize: 69,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/flying_demon/Idle/FlyingDemon_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 7
            },
            walk: {
                pattern: "enemies/flying_demon/Walk/FlyingDemon_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 12
            },
            attack: {
                pattern: "enemies/flying_demon/Attack/FlyingDemon_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 14
            }
        }
    },
    darkAngel: {
        frameSize: 256,
        renderSize: 76,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/dark_angel/Idle/DarkAngel_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 6
            },
            walk: {
                pattern: "enemies/dark_angel/Walk/DarkAngel_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 11
            },
            attack: {
                pattern: "enemies/dark_angel/Attack/DarkAngel_Attack_dir{dir}.png",
                frameCount: 14,
                fps: 14
            }
        }
    },
    treant: {
        frameSize: 256,
        renderSize: 97,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/human_like_tree/Idle/HumanTree_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 5
            },
            walk: {
                pattern: "enemies/human_like_tree/Walk/HumanTree_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 8
            },
            attack: {
                pattern: "enemies/human_like_tree/Attack/HumanTree_Attack_dir{dir}.png",
                frameCount: 14,
                fps: 12
            }
        }
    },
    dragon: {
        frameSize: 256,
        renderSize: 110,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/dragon/Idle/Dragon_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 6
            },
            walk: {
                pattern: "enemies/dragon/Walk/Dragon_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 10
            },
            attack: {
                pattern: "enemies/dragon/Attack/Dragon_Attack_dir{dir}.png",
                frameCount: 16,
                fps: 14
            }
        }
    },
    banditBow: {
        frameSize: 256,
        renderSize: 67,
        directionMap: directionMap,
        animations: {
            idle: {
                pattern: "enemies/bandit_w_bow/Idle/BanditBow_Idle_dir{dir}.png",
                frameCount: 8,
                fps: 6
            },
            walk: {
                pattern: "enemies/bandit_w_bow/Walk/BanditBow_Walk_dir{dir}.png",
                frameCount: 12,
                fps: 12
            },
            attack: {
                pattern: "enemies/bandit_w_bow/Attack/BanditBow_Attack_dir{dir}.png",
                frameCount: 12,
                fps: 12
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
