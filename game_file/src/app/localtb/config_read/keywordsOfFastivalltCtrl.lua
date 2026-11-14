local keywordsOfFastivalltCtrl = class("keywordsOfFastivalltCtrl", include("aAReadClass").new())
function keywordsOfFastivalltCtrl:ctor()
	self:init()
end
local createShieldConfig = function(localtb, ret)
	if not ret then
		ret, _ENV = nil, nil
	end
	for k, v in pairs(localtb) do
		local wordArray = SoraDConvertStringToArray(string.trim(v))
		local tb, lowerWord
		for i, word in ipairs(wordArray) do
			lowerWord = string.lower(word)
			if not tb then
				if not ret[lowerWord] then
					_ENV = ret[lowerWord]
				end
				ret[lowerWord] = ret[lowerWord]
				tb = ret[lowerWord]
			else
				if not tb[lowerWord] then
					_ENV = tb[lowerWord]
				end
				tb[lowerWord] = tb[lowerWord]
				tb = tb[lowerWord]
			end
		end
		tb["end"] = true
	end
	if next(ret) then
		return ret
	end
end
function keywordsOfFastivalltCtrl:init()
	local createData = function(name)
		self.keywords_effect, self, self.keywordsSplit, self = nil, nil, nil, nil
		local config = require_once("app." .. LocalTblPath .. ".config_client.chateffect")
		local lang = userSDKManager.getChannel()
		if lang == "ar" then
			local self, keywordsArab = LocalTblPath, LocalTblPath
			for k, v in pairs(config) do
				if "string" == type(v.arab) and "" ~= v.arab then
					table.insert(keywordsArab, v.arab)
					self.keywords_effect[string.trim(v.arab)] = v.effect
				end
			end
			createShieldConfig(keywordsArab, self.keywordsSplit)
			local self, keywordsEN = createShieldConfig, createShieldConfig
			for k, v in pairs(config) do
				if "string" == type(v.en) and "" ~= v.en then
					table.insert(keywordsEN, v.en)
					self.keywords_effect[string.trim(string.lower(v.en))] = v.effect
				end
			end
			createShieldConfig(keywordsEN, self.keywordsSplit)
		elseif lang == "fa" then
			local self, keywordsArab = LocalTblPath, LocalTblPath
			for k, v in pairs(config) do
				if "string" == type(v.arab) and "" ~= v.arab then
					table.insert(keywordsArab, v.arab)
					self.keywords_effect[string.trim(v.arab)] = v.effect
				end
			end
			createShieldConfig(keywordsArab, self.keywordsSplit)
		else
			local self, keywordsEN = LocalTblPath, LocalTblPath
			for k, v in pairs(config) do
				if "string" == type(v.en) and "" ~= v.en then
					table.insert(keywordsEN, v.en)
					self.keywords_effect[string.trim(string.lower(v.en))] = v.effect
				end
			end
			createShieldConfig(keywordsEN, self.keywordsSplit)
		end
		if name == "keywordsSplit" then
			return self.keywordsSplit
		elseif name == "keywords_effect" then
			return self.keywords_effect
		end
	end
	keywordsOfFastivalltCtrl:defineValue("keywordsSplit", createData)
	keywordsOfFastivalltCtrl:defineValue("keywords_effect", createData)
end
function keywordsOfFastivalltCtrl:marchKewwords(words)
	if "string" ~= type(words) or "" == words then
		return
	end
	local wordArray = SoraDConvertStringToArray(words)
	local n = #wordArray
	local i = 1
	local ret = false
	local eType
	while n >= i do
		local j = i
		local temp = self.keywordsSplit
		local keywords = ""
		while temp and n >= j do
			local word = wordArray[j]
			temp = temp[string.lower(word)]
			if temp then
				keywords = keywords .. string.lower(word)
				if temp["end"] then
					ret = true
					eType = self.keywords_effect[keywords]
				end
				j = j + 1
			end
		end
		i = i + 1
	end
	return ret, eType
end
return keywordsOfFastivalltCtrl
