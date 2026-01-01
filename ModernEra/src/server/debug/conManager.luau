local connection = require(script.Parent.connection)

local manager = {}

-- links[tbl][key] = connection
local links = {}

-- categories[section] = boolean (enabled?)
local categories = {}

function manager.new(tbl, key, section)
	assert(type(tbl) == "table", "manager.new: tbl must be a table")

	section = section or "undefined"

	if not links[tbl] then
		links[tbl] = {}
	end

	if links[tbl][key] then
		return links[tbl][key]
	end

	local conn = connection.new(tbl, key, section)
	links[tbl][key] = conn

	-- default category state = enabled
	if categories[section] == nil then
		categories[section] = true
	end

	-- respect current category state
	if not categories[section] then
		conn:disconnect()
	end

	return conn
end

function manager.remove(tbl, key)
	if not links[tbl] then
		return
	end

	if key then
		links[tbl][key] = nil
	else
		links[tbl] = nil
	end
end

-- disable an entire debug category
function manager.unsubscribeSection(section)
	categories[section] = false

	for _, entryMap in pairs(links) do
		for _, conn in pairs(entryMap) do
			if conn.Section == section then
				conn:disconnect()
			end
		end
	end
end

-- re-enable an entire debug category
function manager.subscribeSection(section)
	categories[section] = true

	for _, entryMap in pairs(links) do
		for _, conn in pairs(entryMap) do
			if conn.Section == section then
				conn:connect()
			end
		end
	end
end

function manager.update()
	for _, entryMap in pairs(links) do
		for _, conn in pairs(entryMap) do
			conn:Update()
		end
	end
end

-- Returns a table of all section names (keys) currently in use
function manager.getSections()
	local sectionList = {}
	for section, _ in pairs(categories) do
		table.insert(sectionList, section)
	end
	return sectionList
end

-- Returns true if the section is currently enabled
function manager.isSectionEnabled(section)
	return categories[section] ~= false
end

return manager
