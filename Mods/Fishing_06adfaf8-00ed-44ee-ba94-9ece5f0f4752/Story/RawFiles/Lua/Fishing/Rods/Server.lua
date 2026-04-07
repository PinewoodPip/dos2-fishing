
---@class Fishing.Rods
local Rods = GetFeature("Fishing.Rods")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Reduce Reel In cooldown by 1 turn when cast while wielding a fishing rod.
Osiris.RegisterSymbolListener("CharacterUsedSkill", 4, "after", function (charGUID, skillID, _, _)
    if skillID == "Target_PIP_Fishing_ReelIn" then
        local char = Character.Get(charGUID)
        if Rods.GetEquippedRod(char) then
            local skillManager = char.SkillManager
            for _,skill in pairs(skillManager.Skills) do
                if skill.SkillId == "Target_PIP_Fishing_ReelIn" then
                    skill.ActiveCooldown = math.max(0, skill.ActiveCooldown - 6 * Rods.ROD_REEL_IN_COOLDOWN_REDUCTION)
                    skill.ShouldSyncCooldown = true
                end
            end
        end
    end
end)

-- Cheat to add all fishing rods.
Ext.RegisterConsoleCommand("fishaddrods", function (_)
    local charGUID = Osi.CharacterGetHostCharacter()
    for _,rod in pairs(Rods._Rods) do
        Osi.ItemTemplateAddTo(rod.RootTemplate, charGUID, 1, 1)
    end
end)
