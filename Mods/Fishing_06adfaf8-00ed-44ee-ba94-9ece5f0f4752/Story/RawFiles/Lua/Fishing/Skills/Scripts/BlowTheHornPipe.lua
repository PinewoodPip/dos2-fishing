
local Fishing = Epip.GetFeature("Features.Fishing")

---@class Features.Fishing.Skills
local Skills = Epip.GetFeature("Fishing", "Features.Fishing.Skills")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Hornpipe status: crits against Wet or Seaburn'd enemies restore Vitality and Magic Armor to the attacker.
-- TODO limit to once per turn?
Ext.Events.StatusHitEnter:Subscribe(function (ev)
    local context = ev.Context
    local attackerHandle = context.Status.HitByHandle
    if Ext.Utils.GetHandleType(attackerHandle) ~= "ServerCharacter" then return end
    local attacker = Character.Get(attackerHandle)
    local status = attacker:GetStatus("PIP_Fishing_Hornpipe")
    if status and ev.Hit.Hit.CriticalHit then
        local VITALITY_PER_POINT = 1
        local MAGIC_ARMOR_PER_POINT = 1
        local statusSource = Character.Get(status.OwnerHandle)
        local sourceFishermancy = Fishing.GetAbilityScore(statusSource)
        local currentHPPercentage = attacker.Stats.CurrentVitality / attacker.Stats.MaxVitality * 100
        local healAmount = VITALITY_PER_POINT * sourceFishermancy
        local healMagicArmorAmount = MAGIC_ARMOR_PER_POINT * sourceFishermancy
        Osi.CharacterSetHitpointsPercentage(attacker.MyGuid, currentHPPercentage + healAmount)
        Osi.CharacterSetMagicArmorPercentage(attacker.MyGuid, currentHPPercentage + healMagicArmorAmount)
        -- TODO some splash visual
    end
end)
