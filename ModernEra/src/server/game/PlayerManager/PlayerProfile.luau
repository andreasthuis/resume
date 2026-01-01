local PlayerProfile = {}
PlayerProfile.__index = PlayerProfile

function PlayerProfile.new(player)
	local self = setmetatable({}, PlayerProfile)

	self.Player = player
	self.Level = 1
	self.XP = 0
	self.OwnedSkins = {}
	self.SelectedSkin = nil

	return self
end

function PlayerProfile:AddXP(amount)
	self.XP += amount
	if self.XP >= 100 then
		self.XP -= 100
		self.Level += 1
	end
end

return PlayerProfile
