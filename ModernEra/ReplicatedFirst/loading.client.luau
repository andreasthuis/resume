local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")

ReplicatedFirst:RemoveDefaultLoadingScreen()

local player = Players.LocalPlayer
local gui = ReplicatedFirst:WaitForChild("LoadingScreen"):Clone()
gui.Parent = player:WaitForChild("PlayerGui")

local bg = gui:WaitForChild("bg")
local bar = bg:WaitForChild("LoadingBar")
local percentLabel = bg:WaitForChild("Percent")

bar.Size = UDim2.fromScale(0, 0.014)

local function updateLoadingGui(progress)
	progress = math.clamp(progress, 0, 1)

	local percent = math.floor(progress * 100)
	percentLabel.Text = percent .. "%"

	TweenService:Create(
		bar,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Size = UDim2.fromScale(progress, 0.014) }
	):Play()
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local preloadList = {}

for _, inst in ipairs(game:GetDescendants()) do
	if inst:IsA("BasePart") or inst:IsA("Sound") or inst:IsA("Decal") or inst:IsA("Texture") or inst:IsA("Animation") then
		table.insert(preloadList, inst)
	end
end

local totalAssets = #preloadList
local loadedAssets = 0

print("Total assets to preload:", totalAssets)

ContentProvider:PreloadAsync(preloadList, function()
	loadedAssets += 1

	local progress = loadedAssets / totalAssets
	updateLoadingGui(progress)
end)

task.wait(0.25)

gui:Destroy()
