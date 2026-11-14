local criAdxRead = include("aAReadClass").new()
criAdxRead:defineValue("criwareAdx_config", "app." .. LocalTblPath .. ".config_client.criwareAdx_config")
local _ENV, cueInfo = criAdxRead.defineValue, criAdxRead.defineValue
local _ENV, selectorInfo = criAdxRead, criAdxRead
local _ENV, selectorLabel = "criwareAdx_config", "criwareAdx_config"
local _ENV, testCue = "app." .. LocalTblPath .. ".config_client.criwareAdx_config", "app." .. LocalTblPath .. ".config_client.criwareAdx_config"
local initInfo = function()
	for name, v in pairs(criAdxRead.criwareAdx_config) do
		if table.nums(v.cueList) ~= 0 then
			table.insert(testCue, v.cueList[1].name)
		end
		for _, cue in ipairs(v.cueList) do
			cueInfo[cue.name] = name
			if cue.selector then
				if not selectorInfo[name] then
					selectorInfo[name], _ENV = selectorInfo[name], selectorInfo[name]
				end
				if not selectorLabel[name] then
					selectorLabel[name], _ENV = selectorLabel[name], selectorLabel[name]
				end
				selectorInfo[name][cue.selector] = cue.name
				selectorLabel[name][cue.selector] = cue.labels
			end
		end
	end
end
function criAdxRead.getAll()
	return criAdxRead.criwareAdx_config
end
function criAdxRead.getAdxConfig(name)
	return criAdxRead.criwareAdx_config[name]
end
function criAdxRead.getAdxType(name)
	return criAdxRead.criwareAdx_config[name] and criAdxRead.criwareAdx_config[name].musicType
end
function criAdxRead.getCueFileName(cueName)
	return cueInfo[cueName]
end
function criAdxRead.getSelectorCueName(fileName, selectorName)
	return selectorInfo[fileName] and selectorInfo[fileName][selectorName]
end
function criAdxRead.getTestCue()
	return testCue
end
initInfo()
return criAdxRead
