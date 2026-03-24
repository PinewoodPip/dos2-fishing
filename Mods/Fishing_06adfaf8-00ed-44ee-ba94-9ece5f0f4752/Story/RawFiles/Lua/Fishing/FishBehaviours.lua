
local Fishing = GetFeature("Fishing")

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias Fishing.Fish.BehaviourType "Chill"|"Aggressive"|"Sinker"|"Floater"|"Unpredictable"

local STATES = {
    FLOATING = "Fishing.GameObject.MovementStates.Floating",
    SINKING = "Fishing.GameObject.MovementStates.Sinking",
    TWEENING = "Fishing.GameObject.MovementStates.Tweening",
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
        InitialState = STATES.SINKING,
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
}
for id,behaviour in pairs(behaviours) do
    behaviour.Type = id
    Fishing.RegisterFishBehaviour(behaviour)
end
