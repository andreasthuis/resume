local Players = game:GetService("Players")

local PlayerProfile = require(script.PlayerProfile)
local RoundPlayer = require(script.RoundPlayer)

local PlayerManager = {}
PlayerManager.__index = PlayerManager

local instance

function PlayerManager.new()
	if instance then
		return instance
	end

	local self = setmetatable({}, PlayerManager)

	self.Profiles = {}
	self.RoundPlayers = {}
	self.Killer = nil

	self.status = "Initializing"

	Players.PlayerAdded:Connect(function(p)
		self:LoadProfile(p)
	end)

	Players.PlayerRemoving:Connect(function(p)
		self:UnloadProfile(p)
	end)

	instance = self

	return self
end

function PlayerManager:LoadProfile(player)
	self.Profiles[player.UserId] = PlayerProfile.new(player)
end

function PlayerManager:UnloadProfile(player)
	self.Profiles[player.UserId] = nil
	self.RoundPlayers[player.UserId] = nil
end

function PlayerManager:SetupRound()
	self.status = "Setting up"
	self.RoundPlayers = {}
	self.Killer = nil

	local playerList = Players:GetPlayers()
	local killer = playerList[math.random(1, #playerList)]

	for _, plr in ipairs(playerList) do
		local round = RoundPlayer.new(self.Profiles[plr.UserId])
		self.RoundPlayers[plr.UserId] = round

		if plr == killer then
			round:SetRole("Killer")
			self.Killer = round
		else
			round:SetRole("Survivor")
		end

		round.OnKilled = function(rp)
			print(rp.Player.Name .. " died!")
		end

		round.OnEscaped = function(rp)
			print(rp.Player.Name .. " escaped!")
		end
	end

	self.status = "Created round players"
end

function PlayerManager:GetRoundPlayer(player)
	for i, rp in pairs(self.RoundPlayers) do
		print(i, rp)
	end
	return self.RoundPlayers[player.UserId]
end

function PlayerManager:SurvivorsAlive()
	local alive = 0
	for _, rp in pairs(self.RoundPlayers) do
		if rp.Role == "Survivor" and rp.IsAlive and not rp.HasEscaped then
			alive += 1
		end
	end
	return alive
end

return PlayerManager.new()
