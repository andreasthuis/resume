local DamageService = require(script.Parent:WaitForChild("DamageService"))

local Sword = {}
Sword.__index = Sword

local Players = game:GetService("Players")

function Sword.new(tool, player)
	assert(tool and tool:IsA("Tool"), "Sword.new: Invalid tool")
	assert(player and player:IsA("Player"), "Sword.new: Invalid player")

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local handle = tool:WaitForChild("Handle")

	local self = setmetatable({}, Sword)

	self.Tool = tool
	self.Player = player
	self.Character = character
	self.Humanoid = humanoid
	self.Handle = handle

	self.Damage = {
		Light = 10,
		Heavy = 25,
	}

	self.CanHit = false
	self.Equipped = false

	self:_connectEvents()

	return self
end

function Sword:_connectEvents()
	self.Tool.Activated:Connect(function()
		self:Attack()
	end)

	self.Tool.Equipped:Connect(function()
		self.Equipped = true
		self.CanHit = true
	end)

	self.Tool.Unequipped:Connect(function()
		self.Equipped = false
		self.CanHit = false
	end)

	self.Handle.Touched:Connect(function(hit)
		self:_onHit(hit)
	end)
end

function Sword:Attack()
	if not self.Equipped then
		return
	end
	if not self.CanHit then
		return
	end

	self.CanHit = false

	task.delay(0.4, function()
		if self.Equipped then
			self.CanHit = true
		end
	end)
end

function Sword:_onHit(hit)
	if not self.Equipped then
		return
	end
	if not self.CanHit then
		return
	end
	if not hit or not hit:IsA("BasePart") then
		return
	end

	local humanoid = hit:FindFirstAncestorOfClass("Model", true)
	if not humanoid then
		return
	end

	humanoid = humanoid:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	if humanoid == self.Humanoid then
		return
	end
	if humanoid.Health <= 0 then
		return
	end

	local character = humanoid.Parent
	if not character or not character:IsA("Model") then
		return
	end

	local targetPlayer = Players:GetPlayerFromCharacter(character)
	if not targetPlayer and targetPlayer.Parent ~= game:GetService("Players") then
		return
	end

	self.CanHit = false

	DamageService:DealDamage(humanoid, self.Damage.Light, targetPlayer)

	task.delay(0.2, function()
		if self.Equipped then
			self.CanHit = true
		end
	end)
end

return Sword
