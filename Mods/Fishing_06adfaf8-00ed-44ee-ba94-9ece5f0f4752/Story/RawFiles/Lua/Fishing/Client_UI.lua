local Generic = Client.UI.Generic
local TextPrefab = Generic.GetPrefab("GenericUI_Prefab_Text")
local Notification = Client.UI.Notification
local PlayerInfo = Client.UI.PlayerInfo
local Minimap = Client.UI.Minimap
local V = Vector.Create

---@class Fishing
local Fishing = GetFeature("Fishing")
local TSK = Fishing.TranslatedStrings
local UI = Generic.Create("Fishing") ---@class Fishing.UI : GenericUI_Instance
Fishing.UI = UI
UI:TryHide()

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
UI._GameObjects = {} ---@type Fishing.GameObject[]
UI._GameObjectClass = nil ---@type Fishing.GameObject
UI._GameObjectClasses = {} ---@type table<string, Fishing.GameObject>
UI._GameObjectStateClass = nil ---@type Fishing.GameObject.State
UI._TreasureChestSpawnTimerID = nil ---@type string?
UI._TreasureChestGameObject = nil ---@type Fishing.GameObject.TreasureChest?
UI._BobberGameObject = nil ---@type Fishing.GameObject.Bobber?

UI.USE_LEGACY_HOOKS = false
UI.Hooks.GetProgressDrain = UI:AddSubscribableHook("GetProgressDrain") ---@type Event<Fishing.UI.Hooks.GetProgressDrain>

---------------------------------------------
-- CONSTANTS
---------------------------------------------

UI.SIZE = V(50, 500)
UI.FISH_SIZE = V(48, 48) -- Game object size.
UI.FISH_ICON_SIZE = V(48, 48)
UI.TREASURE_CHEST_SIZE = V(48, 48)
UI.BOBBER_AREA_SIZE = V(40, 500)
UI.BOBBER_WIDTH = 32
UI.PROGRESS_BAR_COLOR_LOW = Color.CreateFromHex("1A3D5C")
UI.PROGRESS_BAR_COLOR_HIGH = Color.CreateFromHex("87C4E6")

UI.FRAME_TEXTURE = "a5a4c748-ed5b-49ee-8de0-a924b7e529d1"
UI.FRAME_SIZE = UI.BOBBER_AREA_SIZE + V(68 * 2, 110)

-- Physics & tuning
UI.PHYSICS_EXPONENT = 1.8 -- Exponent applied to acceleration (both player & gravity).
UI.GRAVITY = 250
UI.PLAYER_STRENGTH = 550 -- Used to be 400
UI.MAX_VELOCITY = 220
UI.MAX_ACCELERATION = 150
UI.CLICK_ACCELERATION_BOOST = 0 -- TODO add cooldown?
UI.PROGRESS_PER_SECOND = 0.15
UI.PROGRESS_BAR_WIDTH = 20
UI.TUTORIAL_PROGRESS_DRAIN_MULTIPLIER = 0.5
UI.TREASURE_CHEST_EARLY_SPAWN_PROGRESS_THRESHOLD = 0.8 -- Progress threshold past which a queued chest will spawn immediately, skipping the timer.

---------------------------------------------
-- EVENTS/HOOKS
---------------------------------------------

---@class Fishing.UI.Hooks.GetProgressDrain
---@field Drain integer Hookable.
---@field GameState Fishing.GameState
---@field Character EclCharacter
---@field Fish Fishing.Fish

---------------------------------------------
-- METHODS
---------------------------------------------

---Initializes & shows the minigame UI for char.
---@param char EclCharacter
function UI.Start(char)
    UI._CharacterHandle = char.Handle
    local state = UI.GetGameState()

    -- Create bobber
    local bobberSize = Fishing.GetBobberSize(char)
    local bobber = UI.GAME_OBJECT_CLASSES.BOBBER:Create("Bobber", V(UI.BOBBER_WIDTH, bobberSize), UI._GameObjectStateClass:Create())
    UI.BobberElement:SetSize(V(UI.BOBBER_WIDTH, bobberSize):unpack())
    UI._CurrentBobberSize = bobberSize -- Cached to avoid it from changing throughout the minigame if char's bobber size stat changes.
    UI.AddGameObject(bobber)
    UI._BobberGameObject = bobber

    -- Initialize fish and place it around the middle point
    local fish = UI.GAME_OBJECT_CLASSES.FISH:Create(state.CurrentFish, "Fish", UI.FISH_SIZE, UI._GameObjectStateClass:Create())
    local initialStateClass = Fishing.GetBehaviour(state.CurrentFish.Behaviour).InitialState
    local initialState = fish:CreateState(initialStateClass)
    fish:SetState(initialState)
    fish:GetState().Position = UI.GetBobberUpperBound() / 2
    fish:SetProgress(Fishing.GetStartingProgress(char) * fish:GetRequiredProgress())
    UI._FishGameObject = fish
    UI.AddGameObject(fish)

    UI.UpdatePosition()
    UI.UpdateProgressBar()
    UI.UpdateFishIcon()
    UI.UpdateTutorialText()
    UI._ClearTreasureChest()
    UI._TryQueueTreasureChest()

    -- Animate opening
    UI.Root:Tween(UI.OPEN_TWEEN)

    UI:Show()

    GameState.Events.RunningTick:Subscribe(UI._OnTick, nil, "Fishing.UI.Tick")
end

---Returns the minigame state model.
---@return Fishing.GameStates.Fishing?
function UI.GetGameState()
    if not UI._CharacterHandle then return nil end
    local char = Character.Get(UI._CharacterHandle)
    if not char then return nil end
    local state = Fishing.GetState(char) ---@cast state Fishing.GameStates.Fishing
    return state
end

---@return EclCharacter?
function UI.GetCharacter()
    local state = UI.GetGameState()
    local char = state and Character.Get(state.CharacterHandle) ---@type EclCharacter
    return char
end

---Returns how much progress should drain per second.
---@see Fishing.UI.Hooks.GetProgressDrain
---@return number
function UI.GetProgressDrain()
    local char = UI.GetCharacter()
    local state = UI.GetGameState()
    local drain = Fishing.GetProgressDrain(char)
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
    local fish = UI.GetFishGameObject()
    local requiredProgress = fish:GetRequiredProgress()
    local newProgress = fish:AddProgress(progress)

    UI.UpdateProgressBar()

    -- If a chest is queued but not yet spawned, spawn it immediately
    -- if progress crosses a threshold so the player cannot miss it.
    if UI._TreasureChestSpawnTimerID and not UI.GetTreasureChestGameObject() then
        local relativeProgress = newProgress / requiredProgress
        if relativeProgress >= UI.TREASURE_CHEST_EARLY_SPAWN_PROGRESS_THRESHOLD then
            UI._CancelChestSpawnTimer()
            UI.SpawnTreasureChest()
        end
    end

    if newProgress >= requiredProgress then
        UI.Cleanup("Success")
    elseif newProgress <= 0 then
        UI.Cleanup("Failure")
    end
end

---Returns the gameobject of the fish being caught.
---@return Fishing.GameObject.Fish
function UI.GetFishGameObject()
    return UI._FishGameObject
end

---Returns the gameobject of the treasure chest, if any.
---@return Fishing.GameObject.TreasureChest?
function UI.GetTreasureChestGameObject()
    return UI._TreasureChestGameObject
end

---Returns the gameobject of the bobber.
---@return Fishing.GameObject.Bobber?
function UI.GetBobberGameObject()
    return UI._BobberGameObject
end

---Spawns the treasure chest in the minigame.
---**Throws if a chest already exists.**
function UI.SpawnTreasureChest()
    if UI.GetTreasureChestGameObject() then
        UI:__Error("SpawnTreasureChest", "Treasure chest already exists")
        return
    end
    local chestDescriptor = Fishing.GetRandomTreasureChest()
    local chestTemplate = Ext.Template.GetTemplate(chestDescriptor.Template) ---@cast chestTemplate ItemTemplate
    local state = UI.GetGameState()
    state.SpawnedChest = chestDescriptor

    -- Create game object
    local chest = UI.GAME_OBJECT_CLASSES.TREASURE_CHEST:Create("TreasureChest", UI.TREASURE_CHEST_SIZE, UI._GameObjectStateClass:Create())
    chest:GetState().Position = math.random() * UI.GetBobberUpperBound()
    UI._TreasureChestGameObject = chest
    UI.Elements.TreasureChestIcon:SetIcon(chestTemplate.Icon, UI.TREASURE_CHEST_SIZE:unpack())
    UI.AddGameObject(chest)

    -- Show notification
    Notification.ShowNotification(TSK.Notification_TreasureChestSpawned:GetString())

    Net.PostToServer(Fishing.NETMSG_FOUND_TREASURE_CHEST, {
        CharacterNetID = UI.GetCharacter().NetID,
        TreasureChestID = chestDescriptor.ID,
    })
end

---Marks the current treasure chest as caught and removes it.
function UI.CaptureTreasureChest()
    if not UI.GetTreasureChestGameObject() then
        UI:__Error("CaptureTreasureChest", "No treasure chest")
        return
    end
    local state = UI.GetGameState()
    state.CaughtChest = true
    UI._ClearTreasureChest()
    UI:PlaySound("UI_Gen_Default")
end

---Returns how much progress is required to catch a game object.
---@param capturable Fishing.Minigame.GameObjects.Capturable? Defaults to the current fish.
---@returns number
function UI.GetRequiredProgress(capturable)
    capturable = capturable or UI.GetFishGameObject()
    return capturable:GetRequiredProgress()
end

---@param reason Fishing.MinigameExitReason
function UI.Cleanup(reason)
    local state = UI.GetGameState()

    UI._CharacterHandle = nil
    UI._GameState = nil
    UI._FishGameObject = nil
    UI._BobberGameObject = nil
    UI._ClearTreasureChest()
    UI._GameObjects = {}

    GameState.Events.RunningTick:Unsubscribe("Fishing.UI.Tick")

    UI:Hide()

    Fishing.Stop(Character.Get(state.CharacterHandle), reason)
end

---@return Fishing.GameObject[]
function UI.GetGameObjects()
    return UI._GameObjects
end

---Updates the progress bar widget.
function UI.UpdateProgressBar()
    local fish = UI.GetFishGameObject()
    local element = UI:GetElementByID("ProgressBar") ---@type GenericUI_Element_Color
    local relativeProgress = fish.Progress / fish:GetRequiredProgress()
    local length = relativeProgress * UI.SIZE[2] * 1.05

    element:SetColor(Color.Lerp(UI.PROGRESS_BAR_COLOR_LOW, UI.PROGRESS_BAR_COLOR_HIGH, relativeProgress))
    element:SetSize(UI.PROGRESS_BAR_WIDTH, length)
    element:SetPosition(UI.FRAME_SIZE[1] - 120 + UI.SIZE[1], UI.SIZE[2] - length + 70)
end

---Updates the icon of the fish element.
function UI.UpdateFishIcon()
    local state = UI.GetGameState()
    local icon = Fishing.IsFishDiscovered(state.CurrentFish.ID) and state.CurrentFish:GetIcon() or state.CurrentFish.UndiscoveredIcon
    UI.Elements.FishIcon:SetIcon(icon, UI.FISH_ICON_SIZE:unpack())
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
    return UI.BOBBER_AREA_SIZE[2] - UI._CurrentBobberSize
end

---@param className string
---@param class Fishing.GameObject
function UI.RegisterGameObject(className, class)
    UI._GameObjectClasses[className] = class
end

---Adds a game object to the minigame.
---@param gameObject Fishing.GameObject
function UI.AddGameObject(gameObject)
    table.insert(UI._GameObjects, gameObject)
    gameObject:UpdatePosition()
    gameObject:GetElement():SetVisible(true)
end

---Removes a game object from the minigame.
---@param gameObject Fishing.GameObject
function UI.RemoveGameObject(gameObject)
    for i,otherObj in ipairs(UI._GameObjects) do
        if otherObj == gameObject then
            gameObject:GetElement():SetVisible(false)
            table.remove(UI._GameObjects, i)
            return
        end
    end
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

    -- Capture chests
    local chest = UI.GetTreasureChestGameObject()
    if chest and chest.Progress >= chest:GetRequiredProgress() then
        UI.CaptureTreasureChest()
    end
end

----Sets up the timer to spawn a treasure chest, if the random roll for a chest succeeds.
---**Will remove any existing chests first.**
function UI._TryQueueTreasureChest()
    UI._ClearTreasureChest()
    local char = UI.GetCharacter()

    -- Spawn chest after a delay
    if math.random() <= Fishing.GetTreasureChestChance(char) then
        local minDelay, maxDelay = table.unpack(Fishing.TUNING.TREASURE_CHEST_SPAWN_DELAY_RANGE)
        local delay = minDelay + math.random() * (maxDelay - minDelay)
        local timerID = "Fishing.UI.TreasureChestSpawn." .. char.MyGuid
        UI._TreasureChestSpawnTimerID = timerID
        Timer.Start(timerID, delay, function (_)
            UI._TreasureChestSpawnTimerID = nil
            UI.SpawnTreasureChest()
        end)
    end
end

---Cancels the pending treasure chest spawn timer, if any.
function UI._CancelChestSpawnTimer()
    if not UI._TreasureChestSpawnTimerID then return end
    local timer = Timer.GetTimer(UI._TreasureChestSpawnTimerID)
    if timer then timer:Cancel() end
    UI._TreasureChestSpawnTimerID = nil
end

---Removes the current treasure chest or its spawn timer, if any.
function UI._ClearTreasureChest()
    UI._CancelChestSpawnTimer()
    -- Remove game object
    if UI._TreasureChestGameObject then
        UI.RemoveGameObject(UI._TreasureChestGameObject)
        UI._TreasureChestGameObject = nil
    end
end

---Returns the minigame UI instance.
---@return GenericUI_Instance
function Fishing.GetUI()
    return Fishing.UI
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Starting to click gives a boost to acceleration.
Client.Input.Events.MouseButtonPressed:Subscribe(function (ev)
    if ev.InputID == "left2" then
        for _,gameObject in ipairs(UI.GetGameObjects()) do
            if gameObject:GetClassName() == "Fishing.GameObject.Bobber" then
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
    if not UI.GetGameState() then return end -- Skip rest of the listener if the minigame ended as a result of adding progress.

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

-- Apply Thievery reduction while the bobber is colliding with a treasure chest.
UI.Hooks.GetProgressDrain:Subscribe(function (ev)
    local bobber = UI.GetBobberGameObject()
    local chest = UI.GetTreasureChestGameObject()
    if bobber and chest and bobber:IsCollidingWith(chest) then
        ev.Drain = ev.Drain * Fishing.GetTreasureChestProgressDrainMultiplier(ev.Character)
    end
end)

---------------------------------------------
-- SETUP
---------------------------------------------

function Fishing:__Setup()
    -- Cache classes
    UI.GAME_OBJECT_CLASSES = {
        BOBBER = Fishing:GetClass("Fishing.GameObject.Bobber"),
        FISH = Fishing:GetClass("Fishing.GameObject.Fish"),
        TREASURE_CHEST = Fishing:GetClass("Fishing.GameObject.TreasureChest"),
    }

    local panel = UI:CreateElement("Root", "GenericUI_Element_TiledBackground")
    panel:SetBackground("Black", UI.SIZE:unpack())
    panel:SetAlpha(0)
    UI.Root = panel

    local backdropShadow = panel:AddChild("BackdropShadow", "GenericUI_Element_TiledBackground")
    backdropShadow:SetBackground("Black", V(90, UI.BOBBER_AREA_SIZE[2] + 35):unpack())
    -- backdropShadow:Move(30, 20)
    backdropShadow:SetAlpha(0.5)

    -- Progress bar
    local progressBar = panel:AddChild("ProgressBar", "GenericUI_Element_Color")
    progressBar:SetSize(0, 0)
    UI.Elements.ProgressBar = progressBar

    local frameBG = panel:AddChild("BobberAreaBG", "GenericUI_Element_Texture")
    frameBG:SetTexture(UI.FRAME_TEXTURE, UI.FRAME_SIZE)

    local bobberArea = panel:AddChild("BobberArea", "GenericUI_Element_TiledBackground")
    bobberArea:SetBackground("Black", UI.BOBBER_AREA_SIZE:unpack())
    bobberArea:SetAlpha(0, false)
    bobberArea:SetPositionRelativeToParent("Center", -10, -47)
    backdropShadow:SetPositionRelativeToParent("Center", -15 + 10, -40 + 40)

    local gameObjectsContainer = bobberArea:AddChild("GameObjectsContainer", "GenericUI_Element_Empty")
    UI.GameObjectsContainer = gameObjectsContainer
    gameObjectsContainer:SetSizeOverride(UI.BOBBER_AREA_SIZE)

    local bobber = gameObjectsContainer:AddChild("Bobber", "GenericUI_Element_Color")
    bobber:SetSize(V(UI.BOBBER_WIDTH, 40):unpack()) -- Placeholder height; will be set upon starting the minigame.
    bobber:SetColor(Color.Create(0, 0, 0)) -- Will be overwritten later based on rod equipped.
    UI.BobberElement = bobber

    local fish = gameObjectsContainer:AddChild("Fish", "GenericUI_Element_Empty")
    local fishIcon = fish:AddChild("FishIcon", "GenericUI_Element_IggyIcon")
    fishIcon:SetIcon("Item_CON_Food_Fish_B", UI.FISH_ICON_SIZE:unpack())
    fishIcon:Move(-UI.FISH_ICON_SIZE[1]/2 - 5, UI.FISH_ICON_SIZE[2]/2) -- Center the icon in the fish element
    UI.Elements.Fish = fish
    UI.Elements.FishIcon = fishIcon

    local treasureChest = gameObjectsContainer:AddChild("TreasureChest", "GenericUI_Element_Empty")
    local treasureChestIcon = treasureChest:AddChild("TreasureChestIcon", "GenericUI_Element_IggyIcon")
    treasureChestIcon:SetIcon("Item_CONT_Humans_Citz_Chest_A", UI.TREASURE_CHEST_SIZE:unpack()) -- TODO extract icon var
    treasureChestIcon:Move(-UI.TREASURE_CHEST_SIZE[1]/2 - 5, UI.TREASURE_CHEST_SIZE[2]/2)
    treasureChest:SetVisible(false)
    UI.Elements.TreasureChest = treasureChest
    UI.Elements.TreasureChestIcon = treasureChestIcon

    local tutorialText = TextPrefab.Create(UI, "TutorialText", panel, TSK.Label_MinigameTutorial:Format({Color = Color.WHITE}), "Left", V(300, 200))
    tutorialText:SetStroke(Color.Create(Color.BLACK), 1, 1, 25, 15)
    tutorialText:SetPositionRelativeToParent("Right", tutorialText:GetWidth(), 0)
    UI.Elements.TutorialText = tutorialText

    UI:Hide()
end
