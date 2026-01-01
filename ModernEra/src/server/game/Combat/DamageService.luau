local DamageService = {}

local plrManager = require(game.ServerScriptService.Server.game.PlayerManager)

function DamageService:Tag(humanoid, player)
	if not player then
		return
	end

	local tag = Instance.new("ObjectValue")
	tag.Name = "creator"
	tag.Value = player
	tag.Parent = humanoid

	task.delay(2, function()
		if tag then
			tag:Destroy()
		end
	end)
end

function DamageService:DealDamage(humanoid, amount, player)
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	local userId
	if typeof(player) == "Instance" and player:IsA("Player") then
		userId = player.UserId
	elseif type(player) == "number" then
		userId = player
	end

	local roundPlayer
	if userId then
		roundPlayer = plrManager:GetRoundPlayer(player)
	end

	if roundPlayer then
		roundPlayer:Damage(amount)
	end

	self:Tag(humanoid, typeof(player) == "Instance" and player or nil)
end

return DamageService
