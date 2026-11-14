local H_LEN = 230
local W_LEN2 = 348
local W_LEN3 = 196
local SIZE = 122
local OFFSETY = 35
local LIGHT_COLOR = cc.c4b(242, 228, 39, 255)
local GRAY_COLOR = cc.c4b(9, 51, 52, 255)
local collegeDesRead = include("collegeDesRead")
local manorTechRead = include("manorTechRead")
local manorCityUtil = include("manorCityUtil")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_techMap = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorTech/Com_techMap", Com_techMap)
function Com_techMap:onInit()
end
function Com_techMap:onShow()
end
function Com_techMap:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TECH_QUEUE", handler(self, self.updateLine))
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateLine))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_LV_UP", handler(self, self.onMsgBuildLvUp))
end
function Com_techMap:init()
	self.tree = self:getShowTechTree()
	self.fields.Com_tech:removeAllChildren()
	self.fields.Com_line_bg:removeAllChildren()
	self.fields.Com_line_light:removeAllChildren()
	self.lineArray, _ENV, self.techTree, _ENV = self.fields.Com_line_light.removeAllChildren, self.fields.Com_line_light.removeAllChildren, self.fields.Com_line_light.removeAllChildren, self.fields.Com_line_light.removeAllChildren
	local floorCount = 0
	local jumpToObj
	for _, v in ipairs(self.tree) do
		floorCount = math.max(floorCount, v.techPos[1])
		local obj = fguiHelper.createObject("ManorTech", "techSingle")
		local x = self:getWidth() / 2 - SIZE / 2
		local len = #v.techPos == 2 and W_LEN2 or W_LEN3
		if v.techPos[2] == 1 then
			x = self:getWidth() / 2 - len / 2 - SIZE / 2
		elseif v.techPos[2] == 3 then
			x = self:getWidth() / 2 + len / 2 - SIZE / 2
		end
		local y = OFFSETY + H_LEN * (v.techPos[1] - 1)
		obj:setPosition(cc.p(x, y))
		obj:init(v.technologyID)
		self.fields.Com_tech:addChild(obj)
		self.techTree[v.technologyID] = obj
		local isOpen = self:isOpenedLv(v.technologyID)
		local isMax = self:isToMax(v.technologyID)
		if isOpen and not isMax and not jumpToObj then
			jumpToObj = obj
		end
	end
	for _, v in ipairs(self.tree) do
		local cfg = collegeDesRead.getTechCfg(v.technologyID, 1, true)
		if next(cfg) then
			for _, preTechID in ipairs(cfg) do
				local tid = math.floor(preTechID / 100)
				local fromObj = self.techTree[tid]
				local toObj = self.techTree[v.technologyID]
				if fromObj and toObj then
					local fromPos = cc.p(fromObj:getPositionX() + SIZE / 2, fromObj:getPositionY() + SIZE / 2)
					local toPos = cc.p(toObj:getPositionX() + SIZE / 2, toObj:getPositionY() + SIZE / 2)
					local isOpen = self:isOpenedLv(v.technologyID)
					local line = SoraDDrawLine(fromPos, toPos, isOpen and LIGHT_COLOR or GRAY_COLOR)
					line:setPosition(fromPos)
					self.fields.Com_line_bg:addChild(line)
					_ENV = line
					line.fromPos = fromPos
					line.toPos = toPos
					line.toTid = tonumber(v.technologyID)
					table.insert(self.lineArray, line)
				end
			end
		end
	end
	self:getScrollPane():setContentSize(self:getWidth(), OFFSETY + H_LEN * floorCount)
	if jumpToObj then
		self:scrollToObj(jumpToObj)
	end
end
function Com_techMap:getShowTechTree()
	local _ENV, ret
	local _ENV, hiddenTechs
	local showBuildLv = self:getShowBuildLv()
	for _, v in ipairs(manorTechRead.getTechTree()) do
		local needLv = self:getTechNeedBuildLv(v.technologyID)
		if self:checkShowTechByNeedLv(needLv, showBuildLv) then
			table.insert(ret, v)
		else
			_ENV = v
			v.technologyID = v.technologyID
			v.techName = i18n(v.techName)
			v.techPos = v.techPos
			v.needSmartPalaceLv = needLv
			table.insert(hiddenTechs, v)
		end
	end
	self:printShowTechLog(showBuildLv, hiddenTechs)
	return ret
end
function Com_techMap:getShowBuildLv()
	return manorCityUtil.getBuildLvLimit(MANOR_BUILD_ID.SMART_PALACE)
end
function Com_techMap:checkShowTech(technologyID, showBuildLv)
	local needLv = self:getTechNeedBuildLv(technologyID)
	return self:checkShowTechByNeedLv(needLv, showBuildLv)
end
function Com_techMap:checkShowTechByNeedLv(needLv, showBuildLv)
	return not needLv or needLv <= showBuildLv
end
function Com_techMap:getTechNeedBuildLv(technologyID)
	local cfgList = collegeDesRead.getTechGroupCfg(tonumber(technologyID))
	local firstLvCfg
	for _, cfg in ipairs(cfgList) do
		if cfg.technologyLevel == 1 then
			firstLvCfg = cfg
			break
		end
	end
	firstLvCfg = firstLvCfg or cfgList[1]
	if not firstLvCfg or not firstLvCfg.technologyBuild then
		local collegeDesRead, technologyBuild = firstLvCfg.technologyBuild, firstLvCfg.technologyBuild
	end
	for i = 1, #technologyBuild, 2 do
		local buildId = technologyBuild[i]
		local buildLv = technologyBuild[i + 1]
		if tonumber(buildId) == MANOR_BUILD_ID.SMART_PALACE then
			return tonumber(buildLv) or 0
		end
	end
end
function Com_techMap:printShowTechLog(showBuildLv, hiddenTechs)
	if not self:isUnityEditor() then
		return
	end
	local curLv = manorCityCtrl:getBuildLvByBid(MANOR_BUILD_ID.SMART_PALACE)
	print(string.format("ManorTechView show tech rule: smartPalaceLv=%s, smartPalaceMaxCanUpgradeLv=%s, hiddenTechCount=%s", tostring(curLv), tostring(showBuildLv), tostring(#hiddenTechs)))
	dump(hiddenTechs, "ManorTechView hidden techs need smart palace lv", 10)
end
function Com_techMap:isUnityEditor()
	local unityEngine = UnityEngine
	if not (unityEngine and unityEngine.Application) or not unityEngine.RuntimePlatform then
		return false
	end
	local platform = unityEngine.Application.platform
	local runtimePlatform = unityEngine.RuntimePlatform
	return platform == runtimePlatform.WindowsEditor or platform == runtimePlatform.OSXEditor or platform == runtimePlatform.LinuxEditor
end
function Com_techMap:isOpenedLv(id)
	if not technologyCtrl:getTechnoDataByID(id, "manor") then
		local technologyCtrl, singleData = technologyCtrl:getTechnoDataByID(id, "manor"), technologyCtrl:getTechnoDataByID(id, "manor")
	end
	return singleData.isOpened or false
end
function Com_techMap:isToMax(id)
	if not technologyCtrl:getTechnoDataByID(id, "manor") then
		local technologyCtrl, singleData = technologyCtrl:getTechnoDataByID(id, "manor"), technologyCtrl:getTechnoDataByID(id, "manor")
	end
	return singleData.isOpened and singleData.currentLevel >= singleData.maxLevel
end
function Com_techMap:updateLine()
	for k, v in ipairs(self.lineArray) do
		local isOpenedTo = self:isOpenedLv(v.toTid)
		if isOpenedTo and not v.lineLight then
			local line = SoraDDrawLine(v.fromPos, v.toPos, LIGHT_COLOR, 3, 3)
			self.fields.Com_line_light:addChild(line)
			v.lineLight = line
		end
	end
end
function Com_techMap:onMsgBuildLvUp(target, event)
	if not event then
		event, _UPVALUE0_ = nil, nil
	end
	self:init()
	self:initData()
end
function Com_techMap:initData()
	for _, v in pairs(self.techTree) do
		v:initData()
	end
end
return Com_techMap
