local RoundPlayer = {}
RoundPlayer.__index = RoundPlayer

function RoundPlayer.new(profile)
	local self = setmetatable({}, RoundPlayer)

	self.Profile = profile
	self.Player = profile.Player

	self.Role = "Survivor"
	self.Health = 100
	self.IsAlive = true
	self.HasEscaped = false

	return self
end

function RoundPlayer:SetRole(role)
	self.Role = role
end

function RoundPlayer:Damage(amount)
	if not self.IsAlive then
		return
	end

	self.Health -= amount

	print("damaged by", amount, "current hp", self.Health)

	if self.Health <= 0 then
		self.Health = 0
		self:Die()
	end
end

function RoundPlayer:Die()
	if not self.IsAlive then
		return
	end

	self.IsAlive = false

	if self.OnKilled then
		self.OnKilled(self)
	end
end

function RoundPlayer:Escape()
	if not self.IsAlive then
		return
	end

	self.HasEscaped = true

	if self.OnEscaped then
		self.OnEscaped(self)
	end
end

return RoundPlayer
