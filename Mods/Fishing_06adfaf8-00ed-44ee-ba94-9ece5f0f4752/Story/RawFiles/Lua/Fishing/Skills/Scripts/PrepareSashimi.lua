
local Fishing = GetFeature("Fishing")

---@class Fishing.Skills
local Skills = GetFeature("Fishing.Skills")

Skills.PREPARE_SASHIMI_TUNING = {
    TRY_SASHIMI_STATUS_ID = "PIP_FISHING_TRY_SASHIMI",
}
local TUNING = Skills.PREPARE_SASHIMI_TUNING

---@type GUID.ItemTemplate[]
Skills.SASHIMI_TEMPLATES = {
    "bcc3f515-9f52-4873-9d32-8f99524a3dd7", -- Jackpot fish; TODO replace
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Cast effect: attempt to execute non-boss targets that have Seasick.
Osiris.RegisterSymbolListener("CharacterStatusApplied", 3, "after", function (targetGUID, statusID, causeeGUID)
    if statusID ~= TUNING.TRY_SASHIMI_STATUS_ID then return end
    if Osi.HasActiveStatus(targetGUID, Skills.SEASICK_ID) == 0 or Osi.IsBoss(targetGUID) == 1 then return end

    -- Execute target
    local ownerFishermancy = Fishing.GetAbilityScore(Character.Get(causeeGUID))
    local executeThreshold = 20 + ownerFishermancy * 1
    local vitalityPercentage = Osi.CharacterGetHitpointsPercentage(targetGUID)
    if vitalityPercentage <= executeThreshold then
        Osi.CharacterDie(targetGUID, 1, "FrozenShatter", causeeGUID)

        -- Spawn fish
        local targetPos = Character.Get(targetGUID).WorldPos
        local template = Skills.SASHIMI_TEMPLATES[math.random(1, #Skills.SASHIMI_TEMPLATES)]
        local itemGUID = Osi.CreateItemTemplateAtPosition(template, table.unpack(targetPos))
        Osi.PlayEffect(itemGUID, "RS3_FX_GP_ScriptedEvent_Teleport_GenericSmoke_01", "root")
    end
end)
