local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DebugManager = require(script.conManager)

local GROUP_ID = nil -- optional
local MIN_GROUP_RANK = 200 -- optional

local function isDeveloper(player)
	if RunService:IsStudio() then
		return true
	end

	if player.UserId == game.CreatorId then
		return true
	end

	if GROUP_ID and player:IsInGroup(GROUP_ID) then
		return player:GetRankInGroup(GROUP_ID) >= MIN_GROUP_RANK
	end

	return false
end

local debugEnabled = false
local heartbeatConn

local function enableDebug()
	if debugEnabled then
		return
	end
	debugEnabled = true

	heartbeatConn = RunService.Heartbeat:Connect(function()
		DebugManager.update()
	end)
end

local function disableDebug()
	if not debugEnabled then
		return
	end
	debugEnabled = false

	if heartbeatConn then
		heartbeatConn:Disconnect()
		heartbeatConn = nil
	end
end

local function createButton(parent, text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.fromOffset(10, posY)
	btn.Text = text
	btn.BackgroundTransparency = 0.15
	btn.Parent = parent
	return btn
end

local function buildGui(player)
	local gui = Instance.new("ScreenGui")
	gui.Name = "ServerDebugGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(260, 300)
	frame.Position = UDim2.fromOffset(20, 20)
	frame.BackgroundTransparency = 0.15
	frame.Parent = gui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Text = "Server Debug"
	title.Parent = frame

	local toggleBtn = createButton(frame, "Debug: OFF", 40)

	toggleBtn.MouseButton1Click:Connect(function()
		if debugEnabled then
			disableDebug()
			toggleBtn.Text = "Debug: OFF"
		else
			enableDebug()
			toggleBtn.Text = "Debug: ON"
		end
	end)

	local y = 80

	for section in pairs(DebugManager.getSections()) do
		local btn = createButton(frame, section .. ": ON", y)

		btn.MouseButton1Click:Connect(function()
			if DebugManager.isSectionEnabled(section) then
				DebugManager.unsubscribeSection(section)
				btn.Text = section .. ": OFF"
			else
				DebugManager.subscribeSection(section)
				btn.Text = section .. ": ON"
			end
		end)

		y += 35
	end
end

Players.PlayerAdded:Connect(function(player)
	if not isDeveloper(player) then
		return
	end

	buildGui(player)
end)

for _, player in pairs(Players:GetChildren()) do
	if not isDeveloper(player) then
		return
	end

	buildGui(player)
end
