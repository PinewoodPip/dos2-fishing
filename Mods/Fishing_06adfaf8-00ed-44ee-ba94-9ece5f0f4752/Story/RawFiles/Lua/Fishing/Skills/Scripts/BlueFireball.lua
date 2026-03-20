
local Fishing = GetFeature("Features.Fishing")
local isEE = EpicEncounters.IsEnabled()

---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Cast effect: nearby allies cast a lesser version on a random enemy they can see.
Osiris.RegisterSymbolListener("CharacterUsedSkillAtPosition", 7, "after", function (casterGUID, _, _, _, skillID, _, _)
    if skillID ~= "Projectile_PIP_Fishing_BlueFireball" then return end
    if isEE then return end -- In EE this effect is delegated to a Source Infusion instead.
    local allies = Skills.GetCombatAllies(Character.Get(casterGUID))
    for _,ally in ipairs(allies) do
        local allyFishermancy = Fishing.GetAbilityScore(ally)
        if allyFishermancy < 1 then return end

        -- Cast skill
        local nearbyEnemies = Skills.GetNearbyEnemies(ally, 13)
        -- local casterFishermancy = Fishing.GetAbilityScore(Character.Get(casterGUID))
        if #nearbyEnemies > 0 then
            -- for _=1,casterFishermancy,2 do -- TODO replace with damage bonus?
            local target = nearbyEnemies[math.random(1, #nearbyEnemies)]
            Skills.CastProjectileAt(ally, "Projectile_PIP_Fishing_BlueFireball_AllyReaction", target)
            -- end
        end
    end
end)
