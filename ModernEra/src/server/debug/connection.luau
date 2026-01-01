local connection = {}
connection.__index = connection

function connection.new(tbl, key, section)
	assert(type(tbl) == "table", "connection.new: tbl must be a table")
	assert(key ~= nil, "connection.new: key cannot be nil")

	local self = setmetatable({}, connection)

	self.Table = tbl
	self.Key = key
	self.Section = section or "undefined"

	self.StartValue = tbl[key]
	self.LastValue = tbl[key]

	self.Active = true

	return self
end

function connection:disconnect()
	self.Active = false
end

function connection:connect()
	self.Active = true
end

function connection:Update()
	if not self.Active then
		return
	end

	local current = self.Table[self.Key]

	if current ~= self.LastValue then
		print(`[DEBUG][{self.Section}] {tostring(self.Key)}:`, self.LastValue, "→", current)

		self.LastValue = current
	end
end

return connection
