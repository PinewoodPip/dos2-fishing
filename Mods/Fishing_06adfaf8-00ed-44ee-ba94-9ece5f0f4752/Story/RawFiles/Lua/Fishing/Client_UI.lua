local Generic = Client.UI.Generic
local TextPrefab = Generic.GetPrefab("GenericUI_Prefab_Text")
local PlayerInfo = Client.UI.PlayerInfo
local Minimap = Client.UI.Minimap
local V = Vector.Create

---@class Features.Fishing
local Fishing = GetFeature("Features.Fishing")
local UI = Generic.Create("Features.Fishing") ---@class Features.Fishing.UI : GenericUI_Instance
Fishing.UI = UI
UI:Hide()

---@type GenericUI_ElementTween
UI.OPEN_TWEEN = {
    EventID = "RootScale",
    Duration = 0.2,
    Type = "To",
    Function = "Quadratic",
    Ease = "EaseIn",
    StartingValues = {
        scaleX = 0.1,
        scaleY = 0.1,
    },
    FinalValues = {
        scaleX = 1,
        scaleY = 1,
    },
}
-- Extra margin when preventing the UI from overflowing the screen.
UI.OVERFLOW_MARGINS = {
    BOTTOM = 200,
    RIGHT = 150,
    LEFT = 50,
    CHARACTER_Y = 60,
}

UI.Elements = {} -- Holds references to various important elements of the UI.

UI._CharacterHandle = nil ---@type CharacterHandle The owner of this instance.
UI._GameObjects = {} ---@type Features.Fishing.GameObject[]
UI._GameObjectClass = nil ---@type Features.Fishing.GameObject
UI._GameObjectClasses = {} ---@type table<string, Features.Fishing.GameObject>
UI._GameObjectStateClass = nil ---@type Features.Fishing.GameObject.State

UI.USE_LEGACY_HOOKS = false
UI.Hooks.GetProgressDrain = UI:AddSubscribableHook("GetProgressDrain") ---@type Event<Features.Fishing.UI.Hooks.GetProgressDrain>

---------------------------------------------
-- CONSTANTS
---------------------------------------------

UI.SIZE = V(50, 500)
UI.BLOBBER_AREA_SIZE = V(40, 490)
UI.BLOBBER_SIZE = V(40, 70)
UI.FISH_SIZE = V(32, 32)
UI.FISH_ICON_SIZE = V(32, 32)
UI.BOBBER_COLOR = Color.CreateFromHex(Color.LARIAN.POISON_GREEN)
UI.BOBBER_COLLISION_COLOR = Color.CreateFromHex(Color.LARIAN.GREEN)

-- Physics & tuning
UI.PHYSICS_EXPONENT = 1.8 -- Exponent applied to acceleration (both player & gravity).
UI.GRAVITY = 250
UI.PLAYER_STRENGTH = 550 -- Used to be 400
UI.MAX_VELOCITY = 220
UI.MAX_ACCELERATION = 150
UI.CLICK_ACCELERATION_BOOST = 0 -- TODO add cooldown?
UI.PROGRESS_PER_SECOND = 0.15
UI.PROGRESS_BAR_WIDTH = 5
UI.TUTORIAL_PROGRESS_DRAIN_MULTIPLIER = 0.5

---------------------------------------------
-- EVENTS/HOOKS
---------------------------------------------

---@class Features.Fishing.UI.Hooks.GetProgressDrain
---@field Drain integer Hookable.
---@field GameState Features.Fishing.GameState
---@field Character EclCharacter
---@field Fish Features.Fishing.Fish


---------------------------------------------
-- METHODS
---------------------------------------------

---@return GenericUI_Instance
function Fishing.GetUI()
    return Fishing.UI
end

---Initializes & shows the minigame UI for char.
---@param char EclCharacter
function UI.Start(char)
    UI._CharacterHandle = char.Handle
    local state = UI.GetGameState()

    UI.CreateGameObject("Features.Fishing.GameObject.Bobber", "Bobber", UI.BLOBBER_SIZE)

    -- Initialize fish and place it around the middle point
    local fish = UI.CreateGameObject("Features.Fishing.GameObject.Fish", "Fish", UI.FISH_SIZE)
    fish.Descriptor = state.CurrentFish
    local initialStateClass = Fishing.GetBehaviour(state.CurrentFish.Behaviour).InitialState
    local initialState = fish:CreateState(initialStateClass)
    fish:SetState(initialState)
    fish:GetState().Position = UI.GetBobberUpperBound() / 2

    UI.UpdatePosition()
    UI.UpdateProgressBar()
    UI.UpdateFishIcon()
    UI.UpdateTutorialText()

    -- Animate opening
    UI.Root:Tween(UI.OPEN_TWEEN)

    UI:Show()

    GameState.Events.RunningTick:Subscribe(UI._OnTick, nil, "Features.Fishing.UI.Tick")
end

---Returns the minigame state model.
---@return Features.Fishing.GameStates.Fishing?
function UI.GetGameState()
    local char = Character.Get(UI._CharacterHandle)
    if not char then return nil end
    local state = Fishing.GetState(char) ---@cast state Features.Fishing.GameStates.Fishing
    return state
end

---@return EclCharacter?
function UI.GetCharacter()
    local state = UI.GetGameState()
    local char = state and Character.Get(state.CharacterHandle) ---@type EclCharacter

    return char
end

---Returns how much progress should drain per second.
---@see Features.Fishing.UI.Hooks.GetProgressDrain
---@return number
function UI.GetProgressDrain()
    local drain = Fishing.PROGRESS_DRAIN
    local char = UI.GetCharacter()
    local state = UI.GetGameState()
    local hook = UI.Hooks.GetProgressDrain:Throw({
        GameState = state,
        Character = char,
        Drain = drain,
        Fish = state.CurrentFish,
    })
    return hook.Drain
end

---Adds progress towards catching the fish.
---@param progress number
function UI.AddProgress(progress)
    local state = UI.GetGameState()
    local requiredProgress = UI.GetRequiredProgress()
    local newProgress = state.Progress + progress

    state.Progress = math.clamp(newProgress, 0, requiredProgress)

    UI.UpdateProgressBar()

    if newProgress >= requiredProgress then -- Uses the pre-clamped value to avoid floating point issues.
        UI.Cleanup("Success")
    elseif newProgress <= 0 then
        UI.Cleanup("Failure")
    end
end

---Returns how much progress is required to catch the current fish.
---@returns number
function UI.GetRequiredProgress()
    local state = UI.GetGameState()
    return Fishing.BASE_PROGRESS_REQUIRED * state.CurrentFish.Endurance
end

---@param reason Features.Fishing.MinigameExitReason
function UI.Cleanup(reason)
    local state = UI.GetGameState()

    UI._GameState = nil
    UI._GameObjects = {}

    GameState.Events.RunningTick:Unsubscribe("Features.Fishing.UI.Tick")

    UI:Hide()

    Fishing.Stop(Character.Get(state.CharacterHandle), reason)
end

---@return Features.Fishing.GameObject[]
function UI.GetGameObjects()
    return UI._GameObjects
end

---Updates the progress bar widget.
function UI.UpdateProgressBar()
    local state = UI.GetGameState()
    local element = UI:GetElementByID("ProgressBar") ---@type GenericUI_Element_Color
    local relativeProgress = state.Progress / UI.GetRequiredProgress()
    local length = relativeProgress * UI.SIZE[2]

    element:SetColor(Color.CreateFromHex(Color.LARIAN.YELLOW))
    element:SetSize(UI.PROGRESS_BAR_WIDTH, length)
    element:SetPosition(UI.SIZE[1], UI.SIZE[2] - length)
    -- element:SetPositionRelativeToParent("BottomRight", 5, -length) -- TODO investigate issue
end

function UI.UpdateFishIcon()
    local state = UI.GetGameState()

    UI.Elements.Fish:SetIcon(state.CurrentFish:GetIcon(), UI.FISH_ICON_SIZE:unpack())
end

---Returns whether it's the player's first time playing the minigame.
---@return boolean
function UI.IsTutorial()
    local isFirstPlay = next(Fishing.GetFishCatchCount(UI.GetCharacter())) == nil
    return isFirstPlay
end

function UI.UpdateTutorialText()
    local element = UI.Elements.TutorialText
    element:SetVisible(UI.IsTutorial())
end

---Updates the UI's position to stay by the character.
function UI.UpdatePosition()
    local uiScale = UI:GetUI():GetUIScaleMultiplier()
    local viewport = Ext.UI.GetViewportSize()
    local screenW, screenH = viewport[1], viewport[2]
    local MARGINS = UI.OVERFLOW_MARGINS

    -- Position the UI to the right of the character, if possible
    local char = UI.GetCharacter()
    local charPos = char.WorldPos
    local charScreenPos = Client.WorldPositionToScreen(charPos)
    local x, y = table.unpack(charScreenPos)
    x = x + (UI.SIZE[1] * 3) * uiScale
    y = y - (UI.SIZE[2] / 2 + MARGINS.CHARACTER_Y) * uiScale

    -- Prevent bottom overflow
    local yOverflow = (y + uiScale * (UI.SIZE[2] + MARGINS.BOTTOM) - screenH)
    yOverflow = math.max(0, yOverflow)
    y = y - yOverflow

    -- Prevent right overflow,
    -- adding margin to avoid overlap with minimap
    local rightMargin = UI.SIZE[1] + MARGINS.RIGHT
    if Minimap:IsVisible() then
        local mapFrame = Minimap:GetRoot().map_mc.frame_mc
        rightMargin = rightMargin + mapFrame.width
    end
    local xOverflow = (x + uiScale * rightMargin - screenW)
    xOverflow = math.max(0, xOverflow)
    x = x - xOverflow

    -- Prevent top overflow
    y = math.max(0, y)

    -- Prevent left overflow,
    -- adding margin to avoid overlap with payer portraits
    local dummyPortrait = PlayerInfo:GetRoot().player_array[0]
    local leftMargin = 0
    if dummyPortrait then -- Should always exist.
        leftMargin = (dummyPortrait.frame_mc.x + dummyPortrait.frame_mc.width + MARGINS.LEFT) * uiScale
    end
    x = math.max(leftMargin, x)

    UI:SetPosition(V(x // 1, y // 1))
end

---@return number
function UI.GetBobberUpperBound()
    return UI.BLOBBER_AREA_SIZE[2] - UI.BLOBBER_SIZE[2]
end

---@param className string
---@param class Features.Fishing.GameObject
function UI.RegisterGameObject(className, class)
    UI._GameObjectClasses[className] = class
end

---@generic T
---@param className `T`
---@param elementID string
---@param size Vector2D
---@return T
function UI.CreateGameObject(className, elementID, size)
    local class = UI._GameObjectClasses[className]
    local gameObject = class:Create(elementID, size, UI._GameObjectStateClass.Create())

    table.insert(UI._GameObjects, gameObject)

    return gameObject
end

---@param deltaTime number In milliseconds.
function UI.UpdateGameObjects(deltaTime)
    -- Invoke Update
    for _,gameObject in ipairs(UI._GameObjects) do
        gameObject:Update(deltaTime)
        gameObject:UpdatePosition()
    end

    -- Check for collisions
    for _,gameObject in ipairs(UI._GameObjects) do
        for _,otherObject in ipairs(UI._GameObjects) do
            if gameObject ~= otherObject and gameObject:IsCollidingWith(otherObject) then
                gameObject:OnCollideWith(otherObject, deltaTime)
            end
        end
    end

    -- Invoke LateUpdate
    for _,gameObject in ipairs(UI._GameObjects) do
        gameObject:LateUpdate(deltaTime)
    end
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Starting to click gives a boost to acceleration.
Client.Input.Events.MouseButtonPressed:Subscribe(function (ev)
    if ev.InputID == "left2" then
        for _,gameObject in ipairs(UI.GetGameObjects()) do
            if gameObject.Type == "Bobber" then
                local state = gameObject:GetState()

                state.Acceleration = state.Acceleration + UI.CLICK_ACCELERATION_BOOST
            end
        end
    end
end)

-- Cancel the minigame when the character is switched.
Client.Events.ActiveCharacterChanged:Subscribe(function (_)
    if UI.GetGameState() then
        UI.Cleanup("Cancelled")
    end
end)

-- Listen for requests to exit the minigame with escape.
Client.Input.Events.KeyStateChanged:Subscribe(function (ev)
    if ev.InputID == "escape" and UI:IsVisible() then
        UI.Cleanup("Cancelled")
        ev:Prevent()
    end
end)

---@param ev GameStateLib_Event_RunningTick
function UI._OnTick(ev)
    -- Drain progress.
    UI.AddProgress(-UI.GetProgressDrain() * ev.DeltaTime / 1000)

    UI.UpdatePosition()

    -- Exit the minigame if the client goes into dialogue.
    if Client.IsInDialogue() then
        UI.Cleanup("Cancelled")
    else
        UI.UpdateGameObjects(ev.DeltaTime)
    end
end

-- If the user is catching fish for the first time, slow down the drain
-- so as to let give them more time to get used to the controls.
UI.Hooks.GetProgressDrain:Subscribe(function (ev)
    if UI.IsTutorial() then
        ev.Drain = ev.Drain * UI.TUTORIAL_PROGRESS_DRAIN_MULTIPLIER
    end
end)

---------------------------------------------
-- SETUP
---------------------------------------------

function Fishing:__Setup()
    local panel = UI:CreateElement("Root", "GenericUI_Element_TiledBackground")
    panel:SetBackground("Black", UI.SIZE:unpack())
    panel:SetAlpha(0.5)

    local bobberArea = panel:AddChild("BobberArea", "GenericUI_Element_TiledBackground")
    bobberArea:SetBackground("Black", UI.BLOBBER_AREA_SIZE:unpack())
    bobberArea:SetPositionRelativeToParent("Center")

    local bobber = bobberArea:AddChild("Bobber", "GenericUI_Element_Color")
    bobber:SetSize(UI.BLOBBER_SIZE:unpack())
    bobber:SetColor(UI.BOBBER_COLOR)

    local fish = bobberArea:AddChild("Fish", "GenericUI_Element_IggyIcon")
    fish:SetIcon("Item_CON_Food_Fish_B", UI.FISH_ICON_SIZE:unpack())
    UI.Elements.Fish = fish

    local progressBar = panel:AddChild("ProgressBar", "GenericUI_Element_Color")
    progressBar:SetSize(0, 0)
    UI.Elements.ProgressBar = progressBar

    local tutorialText = TextPrefab.Create(UI, "TutorialText", panel, Text.Format(Fishing.TSK["MinigameTutorialHint"], {Color = Color.WHITE}), "Left", V(300, 200))
    tutorialText:SetStroke(Color.Create(Color.BLACK), 1, 1, 15, 1)
    tutorialText:SetPosition(UI.SIZE[1] + 10, 0)
    UI.Elements.TutorialText = tutorialText

    UI:Hide()
end
