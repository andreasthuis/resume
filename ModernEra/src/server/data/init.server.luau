local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local function GetStoreName()
	return RunService:IsStudio() and "Test" or "Live"
end

local dataManager = require(script.dataManager)
local template = require(script.template)
local profilestore = require(ServerScriptService.ServerPackages.profilestore)

local PlayerStore = profilestore.New(GetStoreName(), template)

local function Initialize(player: Player, profile: typeof(PlayerStore:StartSessionAsync()))
	local leaderstats = Instance.new("Folder")
	leaderstats.Parent = player
	leaderstats.Name = "leaderstats"

	local Gold = Instance.new("NumberValue")
	Gold.Parent = leaderstats
	Gold.Name = "Money"
	Gold.Value = profile.Data.Currency
end

local function PlayerAdded(player: Player)
	local profile = PlayerStore:StartSessionAsync("Player_" .. player.UserId, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing data variables from template

		profile.OnSessionEnd:Connect(function()
			dataManager.Profiles[player] = nil
			player:Kick("Data error occured. Please rejoin.")
		end)
		if player.Parent == Players then
			dataManager.Profiles[player] = profile
			Initialize(player, profile)
		else
			profile:EndSession()
		end
	else
		player:Kick("Data error occured. Please rejoin.")
	end
end

for _, player in Players:GetPlayers() do
	task.spawn(PlayerAdded, player)
end
Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = dataManager.Profiles[player]
	if not profile then
		return
	end
	profile:EndSession()
	dataManager.Profiles[player] = nil
end)
