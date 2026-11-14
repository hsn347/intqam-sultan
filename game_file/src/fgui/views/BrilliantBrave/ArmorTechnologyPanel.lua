local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local technologyLocalData = include("technologyLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArmorTechnologyPanel = class("ArmorTechnologyPanel", baseFguiPanel)
function ArmorTechnologyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArmorTechnologyPanel:ctor", self.viewName)
end
function ArmorTechnologyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ArmorTechnologyPanel:onInit()
	print("=======ArmorTechnologyPanel:onInit")
	self.fields.Com_title:initData(i18n("Soldiers_armor_text_2"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function ArmorTechnologyPanel:onShow()
	print("=======ArmorTechnologyPanel:onShow")
	self.openList, _ENV, self.jumpToTid = self.param and self.param.technologyID, self.param and self.param.technologyID, self.param and self.param.technologyID
	self:initData()
end
function ArmorTechnologyPanel:initData()
	self.jumpIndex = nil
	self.scrollData = self:getScrollData()
	self.fields.List:setNumItems(#self.scrollData)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.016666666666666666)
	;(nil)[2] = ffa.callFunc(function()
		self = nil
		;(nil).index = self.jumpIndex or 1
		;(nil).isOpen = true
		self:updateView(self, nil)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self = nil
		;(nil).index = self.jumpIndex or 1
		;(nil).isOpen = true
		self:updateView(self, nil)
	end)
	self:runAction(ffa.seq(nil))
end
function ArmorTechnologyPanel:updateView(target, data)
	self.openList[data.index] = data.isOpen
	self.fields.List:setNumItems(#self.scrollData)
	self.fields.List:scrollToView(data.index - 1)
end
function ArmorTechnologyPanel:onItemRederer(index, target)
	target:initData(self.scrollData[index + 1], index + 1, self.openList)
end
function ArmorTechnologyPanel:btnHelpClick()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.STAR_BRAVE_STATUS)
end
function ArmorTechnologyPanel:getScrollData()
	local _ENV, ret
	local jumpToIndex
	for quality, info in pairs(technologyLocalData.processData) do
		if self:isOutMaxLv(info.lvLimit[1], info.lvLimit[2]) then
			break
		end
		local _ENV, tmp = self:isOutMaxLv(info.lvLimit[1], info.lvLimit[2]), self:isOutMaxLv(info.lvLimit[1], info.lvLimit[2])
		tmp.quality = quality
		tmp.itemList = info.technologyID
		if quality <= SoraDGetBuildQuality() then
			_ENV = quality
			quality.byUID = true
			if not SoraDConfigGet("Game:processStudyView:OpenLv" .. quality .. "~bool", quality) then
				self.jumpIndex = quality
			end
		end
		for _, technologyID in ipairs(info.technologyID) do
			if self:checkTechUnlock(technologyID) then
				self.jumpIndex = quality
			end
			if self.jumpToTid and self.jumpToTid == technologyID then
				jumpToIndex = quality
			end
		end
		table.insert(ret, tmp)
	end
	if jumpToIndex then
		self.jumpIndex = jumpToIndex
	end
	return ret
end
function ArmorTechnologyPanel:isOutMaxLv(bid, curlv)
	if bid == nil or curlv == nil then
		return false
	end
	local cityltCtrl = include("cityltCtrl")
	local maxlv = cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV)
	if bid == BUILDID.STAR_BRAVE_STATUE then
		local addMaxStarLv = cityltCtrl.buildAttr(bid, BUILD_ATTR.ADDMAXSTARLV)
		local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
		local ret = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.GLORIOUS_STATUE_LEVEL_MAX, maxlv)
		ret = math.min(ret, addMaxStarLv)
		maxlv = math.max(maxlv, ret)
	end
	if curlv > maxlv then
		return true
	end
	return false
end
function ArmorTechnologyPanel:checkTechUnlock(technologyID)
	if not technologyCtrl:getTechnoDataByID(technologyID, "process") then
		local technologyCtrl, singleleData = technologyCtrl:getTechnoDataByID(technologyID, "process"), technologyCtrl:getTechnoDataByID(technologyID, "process")
	end
	local singleDetails = technologyCtrl:getTechnologyDetails(technologyID, singleleData.currentLevel)
	local starbuild = singleDetails.starbuild
	for i, v in ipairs(starbuild) do
		if v.bid == 304 and not v.isContentmented then
			return false
		end
	end
	if singleDetails.upgradeIngTechnology and singleDetails.upgradeIngTechnology[3] then
		return true
	end
	technologyCtrl = technologyID
	technologyID.byUID = true
	return not SoraDConfigGet("Game:processStudyView:unlock" .. technologyID .. "~bool", technologyID)
end
return ArmorTechnologyPanel
