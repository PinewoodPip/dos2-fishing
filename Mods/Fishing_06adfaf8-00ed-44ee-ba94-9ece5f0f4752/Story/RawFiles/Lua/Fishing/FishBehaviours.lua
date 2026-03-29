
local Fishing = GetFeature("Fishing")

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias Fishing.Fish.BehaviourType "Chill"|"Aggressive"|"Sinker"|"Floater"|"Unpredictable"|"Steady"|"Jittery"

local STATES = {
    FLOATING = "Fishing.GameObject.MovementStates.Floating",
    SINKING = "Fishing.GameObject.MovementStates.Sinking",
    TWEENING = "Fishing.GameObject.MovementStates.Tweening",
    SHAKING = "Fishing.GameObject.MovementStates.Shaking",
}
-- Aliases for transitions with weight 1.
local BASE_TRANSITIONS = {
    FLOATING = {
        TargetState = STATES.FLOATING,
        Weight = 1,
    },
    SINKING = {
        TargetState = STATES.SINKING,
        Weight = 1,
    },
    TWEENING = {
        TargetState = STATES.TWEENING,
        Weight = 1,
    },
    SHAKING = {
        TargetState = STATES.SHAKING,
        Weight = 1,
    },
}

-- Register default behaviours.
---@type table<Fishing.Fish.BehaviourType, Fishing.Fish.Behaviour>
local behaviours = {
    ["Chill"] = {
        InitialState = STATES.FLOATING,
        Transitions = {
            [STATES.FLOATING] = {
                BASE_TRANSITIONS.SINKING,
            },
            [STATES.SINKING] = {
                BASE_TRANSITIONS.FLOATING,
            },
        },
    },
    ["Aggressive"] = {
        InitialState = STATES.TWEENING,
        Transitions = {
            [STATES.FLOATING] = {
                BASE_TRANSITIONS.TWEENING,
                {
                    TargetState = STATES.SINKING,
                    Weight = 0.5,
                },
            },
            [STATES.SINKING] = {
                BASE_TRANSITIONS.TWEENING,
                {
                    TargetState = STATES.FLOATING,
                    Weight = 0.5,
                },
            },
            [STATES.TWEENING] = {
                BASE_TRANSITIONS.TWEENING,
                {
                    TargetState = STATES.FLOATING,
                    Weight = 0.4,
                },
                {
                    TargetState = STATES.SINKING,
                    Weight = 0.4,
                },
            },
        },
    },
    ["Sinker"] = {
        InitialState = STATES.SINKING,
        Transitions = {
            [STATES.FLOATING] = {
                BASE_TRANSITIONS.SINKING,
                {
                    TargetState = STATES.FLOATING,
                    Weight = 0.2,
                },
            },
            [STATES.SINKING] = {
                BASE_TRANSITIONS.FLOATING,
                {
                    TargetState = STATES.TWEENING,
                    Weight = 0.6,
                },
                {
                    TargetState = STATES.SINKING,
                    Weight = 0.2,
                },
            },
            [STATES.TWEENING] = {
                BASE_TRANSITIONS.SINKING,
                {
                    TargetState = STATES.FLOATING,
                    Weight = 0.2,
                },
            },
        },
    },
    ["Floater"] = {
        InitialState = STATES.FLOATING,
        Transitions = {
            [STATES.FLOATING] = {
                BASE_TRANSITIONS.SINKING,
                {
                    TargetState = STATES.FLOATING,
                    Weight = 0.2,
                },
            },
            [STATES.SINKING] = {
                BASE_TRANSITIONS.SINKING,
                {
                    TargetState = STATES.TWEENING,
                    Weight = 0.6,
                },
                {
                    TargetState = STATES.SINKING,
                    Weight = 0.2,
                },
            },
            [STATES.TWEENING] = {
                BASE_TRANSITIONS.FLOATING,
                {
                    TargetState = STATES.SINKING,
                    Weight = 0.2,
                },
            },
        },
    },
    -- Like Aggressive, but tweens less frequently.
    ["Steady"] = {
        InitialState = STATES.FLOATING,
        Transitions = {
            [STATES.FLOATING] = {
                BASE_TRANSITIONS.SINKING,
                {
                    TargetState = STATES.TWEENING,
                    Weight = 0.3,
                },
            },
            [STATES.SINKING] = {
                BASE_TRANSITIONS.FLOATING,
                {
                    TargetState = STATES.TWEENING,
                    Weight = 0.3,
                },
            },
            [STATES.TWEENING] = {
                BASE_TRANSITIONS.FLOATING,
                BASE_TRANSITIONS.SINKING,
            },
        },
    },
    ["Unpredictable"] = {
        InitialState = STATES.TWEENING,
        Transitions = {
            [STATES.FLOATING] = {
                BASE_TRANSITIONS.SINKING,
                BASE_TRANSITIONS.TWEENING,
            },
            [STATES.SINKING] = {
                BASE_TRANSITIONS.FLOATING,
                BASE_TRANSITIONS.TWEENING,
            },
            [STATES.TWEENING] = {
                BASE_TRANSITIONS.FLOATING,
                BASE_TRANSITIONS.SINKING,
            },
        }
    },
    -- Alternates between shaking and tweening; erratic.
    ["Jittery"] = {
        InitialState = STATES.SHAKING,
        Transitions = {
            [STATES.SHAKING] = {
                BASE_TRANSITIONS.TWEENING,
                {
                    TargetState = STATES.SHAKING,
                    Weight = 0.5,
                },
            },
            [STATES.TWEENING] = {
                BASE_TRANSITIONS.SHAKING,
                {
                    TargetState = STATES.TWEENING,
                    Weight = 0.3,
                },
            },
        },
    },
}
for id,behaviour in pairs(behaviours) do
    behaviour.Type = id
    Fishing.RegisterFishBehaviour(behaviour)
end
