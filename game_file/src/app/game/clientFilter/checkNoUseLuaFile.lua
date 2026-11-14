local checkNoUseLuaFile = class("checkNoUseLuaFile")
function checkNoUseLuaFile:ctor()
	print("==checkNoUseLuaFile:ctor==")
	print("==checkNoUseLuaFile:end==")
end
function checkNoUseLuaFile:checkLua(...)
	_UPVALUE7_ = nil
	;(nil)[1] = "prop_formula"
	;(nil)[2] = "formula"
	;(nil)[3] = "attributeDef"
	;(nil)[4] = "cityBuildingInfo"
	;(nil)[5] = "filterDef"
	;(nil)[6] = "gameGuideData"
	local (nil)[7], ignore = "technologyDef", nil
	for i, v in ipairs(ignore) do
		ignore[v] = true
	end
	local _ENV, ret = (for generator), ipairs(ignore)
	local basePath = cc.FileUtils:getInstance():getWritablePath()
	for fileName, path in pairs(getNametopath()) do
		if not ignore[fileName] then
			local path2 = string.gsub(path, "%.", "/")
			local fullPath = basePath .. "src/" .. path2 .. ".lua"
			if not cc.FileUtils:getInstance():isFileExist(fullPath) then
				table.insert(ret, fileName)
			elseif type(include(fileName)) ~= "table" then
				table.insert(ret, fileName)
			end
		end
	end
	table.sort(ret)
	dump(ret, "==不存在的lua文件==")
end
function checkNoUseLuaFile:checkCsd(...)
	local _ENV, ret
	local basePath = cc.FileUtils:getInstance():getWritablePath()
	for fileName, path in pairs(getCCSPathTable()) do
		local fullPath1 = basePath .. "res_common/ccsFiles/" .. path .. ".csb"
		local fullPath2 = basePath .. "res_common/ccsFiles_en/" .. path .. ".csb"
		local exist1 = cc.FileUtils:getInstance():isFileExist(fullPath1)
		local exist2 = cc.FileUtils:getInstance():isFileExist(fullPath2)
		if not exist1 and not exist2 then
			table.insert(ret, fileName)
		end
	end
	for fileName, path in pairs(getCommonPathTable()) do
		local fullPath = basePath .. "res_common/ccsCommonFiles/" .. path .. ".csb"
		local exist = cc.FileUtils:getInstance():isFileExist(fullPath)
		if not exist then
			table.insert(ret, fileName)
		end
	end
	dump(ret, "==不存在的csd文件==")
end
function checkNoUseLuaFile:checkFguiConfig(...)
	_UPVALUE30_ = nil
	;(nil)[1] = "citybuffItemView"
	;(nil)[2] = "rankingsScrollView"
	;(nil)[3] = "commonRankAwardView"
	;(nil)[4] = "summerPrayersMainView"
	;(nil)[5] = "heroTrialView"
	;(nil)[6] = "heroTrialArea"
	;(nil)[7] = "heroTrialMapView"
	;(nil)[8] = "combinationView"
	;(nil)[9] = "combinationItem"
	;(nil)[10] = "combinationCostView"
	;(nil)[11] = "rechargePopFrame"
	;(nil)[12] = "rechargeDailyPopView"
	;(nil)[13] = "rechargeFirstAwardDetail"
	;(nil)[14] = "rechargeGiftRewardPopView"
	;(nil)[15] = "rechargeGiftShopCarView"
	;(nil)[16] = "rechargePopView"
	;(nil)[17] = "rechargeView"
	;(nil)[18] = "rechargeVipLimitBox"
	;(nil)[19] = "resourceBuyView"
	;(nil)[20] = "allianceMemberRankInfoView"
	;(nil)[21] = "allianceInviteView"
	;(nil)[22] = "allianceBlackWhiteView"
	;(nil)[23] = "allianceRelationView"
	;(nil)[24] = "allianceActiveView"
	;(nil)[25] = "heroSelectOneView"
	;(nil)[26] = "allianceRelationApplyView"
	;(nil)[27] = "allianceActiveLevelView"
	;(nil)[28] = "allianceActiveRandRewardView"
	;(nil)[29] = "allianceActiveRankView"
	;(nil)[30] = "allianceAttributeView"
	;(nil)[31] = "allianceBlackWhiteHelpView"
	;(nil)[32] = "allianceChangeFlagView"
	;(nil)[33] = "allianceDonateRankingsView"
	;(nil)[34] = "allianceGroupMailView"
	;(nil)[35] = "allianceHuntChallenge"
	;(nil)[36] = "allianceHuntExchangeView"
	;(nil)[37] = "allianceHuntPopView"
	;(nil)[38] = "allianceHuntRank"
	;(nil)[39] = "allianceHuntView"
	;(nil)[40] = "allianceInfoView"
	;(nil)[41] = "allianceMainView"
	;(nil)[42] = "allianceManageView"
	;(nil)[43] = "allianceMemberBattlePointView"
	;(nil)[44] = "allianceMemberList"
	;(nil)[45] = "allianceMemberSetting"
	;(nil)[46] = "allianceMobAwardView"
	;(nil)[47] = "allianceMobView"
	;(nil)[48] = "allianceRelationApplyView"
	;(nil)[49] = "allianceSettingsView"
	;(nil)[50] = "allianceStoreHouseRecordView"
	;(nil)[51] = "allianceStoreHouseView"
	;(nil)[52] = "allianceUnlockMessagesView"
	;(nil)[53] = "allianceWarehouseLogView"
	local (nil)[54], ignore = "allianceWarehouseView", nil
	for __, v in ipairs(ignore) do
		ignore[v] = true
	end
	local _ENV, ret = (for generator), ipairs(ignore)
	for fileName, __ in pairs(getNametopath()) do
		if getPanelConfig(fileName) and not ignore[fileName] then
			table.insert(ret, fileName)
		end
		local name1 = string.sub(fileName, 1, -5)
		local name2 = string.sub(fileName, -4, -1)
		if (name2 == "view" or name2 == "View") and getPanelConfig(name1) and not ignore[fileName] then
			table.insert(ret, fileName)
		end
	end
	table.sort(ret)
	dump(ret, "==fgui重写过的文件==")
end
function checkNoUseLuaFile:checkCustomData_csd(...)
	local _ENV, retMap
	local findCsdPath = function(customData, path, file)
		if tonumber(customData) ~= nil then
			return
		end
		_UPVALUE7_ = tonumber(customData)
		tonumber(customData)[1] = ".usm"
		tonumber(customData)[2] = ".plist"
		tonumber(customData)[3] = ".png"
		tonumber(customData)[4] = ".skel"
		tonumber(customData)[5] = ","
		tonumber(customData)[6] = "{"
		local tonumber(customData)[7], ignoreList = "#", tonumber(customData)
		for __, v in ipairs(ignoreList) do
			if string.find(customData, v) then
				return
			end
		end
		if getCCSPath(customData) then
			return
		end
		retMap[customData] = file
		return true
	end
	local readFlie = function(path, fileName)
		local fullName = path .. "/" .. fileName
		local file = io.open(fullName, "r+")
		local pattern = "customData=\"(.-)\""
		local content = file:read("*l")
		while content do
			if string.find(content, "customData") then
				local customData = string.match(content, pattern)
				findCsdPath(customData, path, fileName)
			end
			content = file:read("*l")
		end
		file:close()
	end
	local lfs = require("lfs")
	local function traverseFolder(path)
		for file in lfs.dir(path) do
			if file ~= "." and file ~= ".." then
				local filePath = path .. "/" .. file
				local mode = lfs.attributes(filePath, "mode")
				if mode == "file" then
					if string.find(file, ".xml") then
						readFlie(path, file)
					end
				elseif mode == "directory" then
					traverseFolder(filePath)
				end
			end
		end
	end
	local basePath = cc.FileUtils:getInstance():getWritablePath()
	local folderPath = basePath .. "../FairyGUIProject/assets"
	traverseFolder(folderPath)
	local folderPath = basePath .. "../FairyGUIProject/assets_en"
	traverseFolder(folderPath)
	dump(retMap, "==fgui工程引用的csd文件==")
end
return checkNoUseLuaFile
