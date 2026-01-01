local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerManager = require(script.Parent.PlayerManager)
local Maps = ReplicatedStorage:WaitForChild("Maps")

local MapManager = {}
MapManager.__index = MapManager

local instance

function MapManager.new()
	if instance then
		return instance
	end

	local self = setmetatable({}, MapManager)

	self.Maps = {}
	self.CurrentMap = nil

	self.status = "Initializing"

	instance = self

	return self
end

function MapManager:_SpawnPlayers()
	local profiles = PlayerManager.RoundPlayers
	local killer = PlayerManager.Killer

	for _, rp in pairs(profiles) do
		if rp ~= killer then
			print(rp.Player.Name, "is NOT the killer")
		end
	end
end

function MapManager.LoadMaps()
	for _, map in ipairs(Maps:GetChildren()) do
		table.insert(Maps, map)
	end
end

function MapManager:StartRound() end

function MapManager:LoadMap()
	local map = self.Maps[math.random(0, #self.Maps - 1)]
	self.CurrentMap = map

	return map
end

return MapManager.new()
