local ltBase = include("ltBase")
local shieldedWordsltCtrl = class("shieldedWordsltCtrl", ltBase, include("aAReadClass").new())
local lang = userSDKManager.getChannel()
function shieldedWordsltCtrl:ctor()
	shieldedWordsltCtrl.super.ctor(self)
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
function shieldedWordsltCtrl:init()
	local shieldedWordsList, shieldedNameList
	if _G.IsArClient then
		createShieldConfig = _G.IsArClient
		createShieldConfig, shieldedWordsList, _G.IsArClient[1] = _G.IsArClient, _G.IsArClient, "local_shieldedwords_arab"
		createShieldConfig, shieldedWordsList, _G.IsArClient[2] = _G.IsArClient, _G.IsArClient, "local_shieldedwords_en"
		shieldedNameList, _G.IsArClient[1] = _G.IsArClient, "local_shieldedname_en"
		shieldedNameList, _G.IsArClient[2] = _G.IsArClient, "local_shieldedname_arab"
	end
	local path = "app." .. _G.LocalTblPath .. ".config_client."
	shieldedWordsltCtrl:defineValue("shieldedWordsSplit", function()
		self.shieldedWordsSplit, self = nil, nil
		for _, v in ipairs(shieldedWordsList) do
			local shieldedWordsArab = require(path .. v)
			createShieldConfig(shieldedWordsArab, self.shieldedWordsSplit)
		end
		return self.shieldedWordsSplit
	end)
	shieldedWordsltCtrl:defineValue("shieldedName", function()
		self.shieldedName, self = nil, nil
		for _, v in ipairs(shieldedNameList) do
			local shieldedWordsArab = require(path .. v)
			createShieldConfig(shieldedWordsArab, self.shieldedName)
		end
		return self.shieldedName
	end)
end
function shieldedWordsltCtrl:hasShieldedWord(words)
	if "string" ~= type(words) or "" == string.trim(words) then
		printError("shieldedWordsltCtrl.checkShieldedWords: words = %s", tostring(words))
		return words
	end
	local wordArray = SoraDConvertStringToArray(words)
	local n = #wordArray
	local iter = 1
	local pos
	while n >= iter do
		local nextIter = iter
		pos = iter
		if self:isChatLegality(wordArray[pos]) then
			local _ENV, shieldedWordList = self:isChatLegality(wordArray[pos]), self:isChatLegality(wordArray[pos])
			nextIter = self:findShieldWord(wordArray, self.shieldedWordsSplit, pos, n, shieldedWordList)
			if next(shieldedWordList) then
				return true
			end
			words = self:replaceShieldWord(shieldedWordList, words)
		end
		iter = nextIter + 1
	end
	return false
end
function shieldedWordsltCtrl:isNameShieldWord(words)
	if "string" ~= type(words) or "" == words then
		print("shieldedWordsltCtrl.checkShieldedWords: words = %s", tostring(words))
		return
	end
	local wordArray = SoraDConvertStringToArray(words)
	local n = #wordArray
	_ENV = tostring(words)
	tostring(words)["َ"] = true
	tostring(words)["ً"] = true
	tostring(words)["ُ"] = true
	tostring(words)["ٌ"] = true
	tostring(words)["ِ"] = true
	tostring(words)["ٍ"] = true
	tostring(words)["ْ"] = true
	local tostring(words)["ّ"], specialChat = true, tostring(words)
	for i, v in ipairs(wordArray) do
		if specialChat[v] then
			return true
		end
	end
	local iter = 1
	local pos
	while n >= iter do
		local nextIter = iter
		pos = iter
		if self:isChatLegality(wordArray[pos]) then
			local _ENV, shieldedWordList = self:isChatLegality(wordArray[pos]), self:isChatLegality(wordArray[pos])
			nextIter = self:findShieldWord(wordArray, self.shieldedName, pos, n, shieldedWordList)
			if next(shieldedWordList) then
				return true
			end
			words = self:replaceShieldWord(shieldedWordList, words)
		end
		iter = nextIter + 1
	end
	return false
end
function shieldedWordsltCtrl:isArabAlphabet(str)
	if "string" ~= type(str) or "" == str then
		printError("shieldedWordsltCtrl.checkShieldedWords: words = %s", tostring(str))
		return
	end
	if #str == 2 then
		local char1 = string.byte(str, 1)
		if 216 <= char1 and char1 <= 219 then
			local char2 = string.byte(str, 2)
			if 128 <= char2 and char2 <= 191 then
				return true
			end
		end
	end
	return false
end
function shieldedWordsltCtrl:isEnAlphabet(str)
	if "string" ~= type(str) or "" == str then
		printError("shieldedWordsltCtrl.checkShieldedWords: words = %s", tostring(str))
		return
	end
	if string.match(str, "%a") then
		return true
	end
	return false
end
function shieldedWordsltCtrl:isAlphabet(str)
	if "string" ~= type(str) or "" == str then
		printError("shieldedWordsltCtrl.checkShieldedWords: words = %s", tostring(str))
		return
	end
	if self:isEnAlphabet(str) or self:isArabAlphabet(str) then
		return true
	end
	return false
end
function shieldedWordsltCtrl:isChatLegality(c)
	if lang == "ar" then
		return self:isAlphabet(c)
	elseif lang == "fa" then
		return not string.match(c, "[%s%p]") and not serviceFunctions.isEmojiChar(c)
	else
		return not string.match(c, "[%s%p]") and not serviceFunctions.isEmojiChar(c)
	end
end
function shieldedWordsltCtrl:isNameLegality(words)
	if "string" ~= type(words) or "" == words then
		printError("shieldedWordsltCtrl.isNameLegality: words = %s", tostring(words))
		return
	end
	if string.match(words, "%s%s+") then
		return false
	end
	local wordArray = SoraDConvertStringToArray(words)
	local n = #wordArray
	for i, v in ipairs(wordArray) do
		if not self:isAlphabet(v) and not string.match(v, "%d") and " " ~= v then
			return false
		end
	end
	return true
end
function shieldedWordsltCtrl:isEquipmentSetTitleLegality(words)
	if "string" ~= type(words) or "" == words then
		printError("shieldedWordsltCtrl.isEquipmentSetTitleLegality: words = %s", tostring(words))
		return
	end
	local wordArray = SoraDConvertStringToArray(words)
	local n = #wordArray
	for i, v in ipairs(wordArray) do
		if not self:isAlphabet(v) and not self:isEnAlphabet(v) and not string.match(v, "%d") and " " ~= v then
			return false
		end
	end
	return true
end
function shieldedWordsltCtrl:findShieldWord(wordArray, shieldConfig, beginIter, endIter, shieldedWordList)
	local tempConfig = shieldConfig
	local shieldedWord, subString, subModule
	local tempShieldedWord = ""
	local iter = beginIter
	local beginPos, retIter, firstIllegalPos
	while tempConfig and endIter >= iter do
		local word = wordArray[iter]
		tempConfig = tempConfig[string.lower(word)]
		if tempConfig then
			if not self:isChatLegality(word) and not firstIllegalPos then
				firstIllegalPos = iter
				retIter = firstIllegalPos
			end
			beginPos = beginPos or iter
			tempShieldedWord = tempShieldedWord .. word
			if tempConfig["end"] then
				local nextWord = wordArray[iter + 1]
				if not nextWord then
					shieldedWord = tempShieldedWord
					retIter = iter
					if 1 == math.abs(retIter - beginPos) + 1 then
						subString = "*"
					else
						subString = "**"
					end
					subModule = 1
					_UPVALUE3_ = nil
					;(nil)[1] = shieldedWord
					;(nil)[2] = subModule
					;(nil)[3] = subString
					table.insert(shieldedWordList, nil)
					return retIter
				elseif not self:isChatLegality(nextWord) then
					shieldedWord = tempShieldedWord
					if 1 == math.abs(iter - beginPos) + 1 then
						subString = "*"
					else
						subString = "**"
					end
					subModule = 2
					retIter = iter
				end
			end
			iter = iter + 1
		elseif shieldedWord then
			_UPVALUE3_ = iter - beginPos
			;(iter - beginPos)[1] = shieldedWord
			;(iter - beginPos)[2] = subModule
			;(iter - beginPos)[3] = subString
			table.insert(shieldedWordList, iter - beginPos)
			return retIter
		elseif firstIllegalPos then
			return firstIllegalPos
		else
			retIter = iter
			if word and not self:isChatLegality(word) then
				return retIter
			end
			local nextWord = wordArray[retIter + 1]
			while nextWord and self:isChatLegality(nextWord) do
				retIter = retIter + 1
				nextWord = wordArray[retIter + 1]
			end
			return retIter
		end
	end
	if firstIllegalPos then
		return firstIllegalPos
	end
	return endIter
end
function shieldedWordsltCtrl:replaceShieldWord(shieldedWordList, words)
	if "table" == type(shieldedWordList) and next(shieldedWordList) then
		local lastShieldWordInfo = shieldedWordList[#shieldedWordList]
		local shieldedWord = lastShieldWordInfo[1]
		shieldedWord = string.gsub(shieldedWord, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
		local subString = lastShieldWordInfo[3]
		if lastShieldWordInfo[2] == 1 then
			words = string.gsub(words, "(" .. shieldedWord .. ")$", subString)
		elseif lang == "ar" then
			words = string.gsub(words, shieldedWord .. "(%A+)", subString .. "%1", 1)
		else
			words = string.gsub(words, shieldedWord .. "(%A+)", subString .. "%1", 1)
		end
	end
	return words
end
function shieldedWordsltCtrl:replaceShieldedWords(words)
	if not words then
		return
	end
	if "string" ~= type(words) or "" == string.trim(words) then
		printError("shieldedWordsltCtrl.checkShieldedWords: words = %s", tostring(words))
		return words
	end
	local wordArray = SoraDConvertStringToArray(words)
	local n = #wordArray
	local iter = 1
	local pos
	while n >= iter do
		local nextIter = iter
		pos = iter
		if self:isChatLegality(wordArray[pos]) then
			local _ENV, shieldedWordList = self:isChatLegality(wordArray[pos]), self:isChatLegality(wordArray[pos])
			nextIter = self:findShieldWord(wordArray, self.shieldedWordsSplit, pos, n, shieldedWordList)
			words = self:replaceShieldWord(shieldedWordList, words)
		end
		iter = nextIter + 1
	end
	return words
end
local emojiShield
local initEmojiShield = function()
	if not emojiShield then
		emojiShield = emojiShield
		local config = require("app." .. LocalTblPath .. ".config_client.local_shieldedemoji_ar")
		for k, v in pairs(config) do
			emojiShield[v] = true
		end
	end
end
function shieldedWordsltCtrl:hasShieldedEmoji(words)
	if lang == "ar" or lang == "fa" then
		initEmojiShield()
		local wordArray = SoraDConvertStringToArray(words)
		dump(wordArray, "wordArray", 5)
		for i, v in ipairs(wordArray) do
			if emojiShield[v] then
				return true
			end
		end
	end
	return false
end
return shieldedWordsltCtrl
