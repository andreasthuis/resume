local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local conManager = require(ServerScriptService.Server.debug.conManager)
local manager = require(script.PlayerManager)

while true do
	print("Starting new round in 10 seconds...")
	task.wait(10)

	conManager.new(manager, "status", "Round")

	while not RunService:IsStudio() and #manager.Profiles < 4 do
		print(manager.Profiles)
		task.wait(1)
	end

	manager:SetupRound()

	print("Round started. Killer:", manager.Killer.Player.Name)

	-- Round loop
	while manager:SurvivorsAlive() > 0 do
		task.wait(1)
	end

	print("Round ended!")
end
