local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceSetting = SoraDGetCtrl("allianceSetting")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceChangeFlagViewPanel = class("allianceChangeFlagViewPanel", baseFguiPanel)
function allianceChangeFlagViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceChangeFlagViewPanel:ctor", self.viewName)
end
function allianceChangeFlagViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceChangeFlagViewPanel:onInit()
	print("=======allianceChangeFlagViewPanel:onInit")
	self.isHidePrePanel = false
	self.curFlag = 0
	self.tableFlagList, _ENV, self.selectFlag = print, print, 0
	self.fields.Button_cancel:setString(i18n("common_text_184"))
	self.fields.Button_cancel:addClickListener(handler(self, self.btnCancelClick))
	self.fields.Button_change:setString(i18n("common_text_243"))
	self.fields.Button_change:setCostTitle(gConstValue.ALLIANCE_MODIFY_ALLIANCE_FLAG_GOLD)
	self.fields.Button_change:addClickListener(handler(self, self.btnChangeClickCallBack))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.List:setItemRenderer(handler(self, self.onFlagRenderer))
	self.fields.Button_cancel:fixPos()
	self.fields.Button_change:fixPos()
end
function allianceChangeFlagViewPanel:onFlagRenderer(index, obj)
	obj:initData(self.tableFlagList[index + 1], self.selectFlag)
end
function allianceChangeFlagViewPanel:onShow()
	print("=======allianceChangeFlagViewPanel:onShow")
	self:updateView()
end
function allianceChangeFlagViewPanel:selectFlagBack(target, data)
	self.selectFlag = data.flagID
	self:updateFlag()
	self.fields.List:setNumItems(#self.tableFlagList)
end
function allianceChangeFlagViewPanel:updateFlag()
	self.fields.Button_change:setEnabled(self.curFlag ~= self.selectFlag)
	self.fields.Node_flag:clearContent()
	local flagNode = allianceDesRead.getFlagNode(self.selectFlag)
	flagNode:setPosition(5, 5)
	self.fields.Node_flag:setContent(flagNode)
	self.fields.Button_change:setCostTitle(allianceDesRead.getAllianceFlagPrice(self.selectFlag))
	if allianceMgr:getAlliance():isInBestAllianceTime() then
		local leftTime = allianceMgr:getAlliance():getBestAllianceInfo().endTime - serviceFunctions.systemTime()
		self.fields.Text_time:setVisible(self.selectFlag == 16 and 0 < leftTime)
		if 0 < leftTime then
			self.fields.Text_time:setTimeUpdateListener(function(time)
				self = nil
				;(nil).time = SoraDConvertSecondToString(time)
				self.fields.Text_time:setString(i18n("common_text_766", nil))
			end)
			self.fields.Text_time:beginTime(leftTime)
		end
	end
	if allianceMgr:getAlliance():isMobiBestAlliance() then
		local leftTime = allianceMgr:getAlliance():getMobiBestAllianceInfo().endTime - serviceFunctions.systemTime()
		self.fields.Text_time:setVisible(self.selectFlag == 17 and 0 < leftTime)
		if 0 < leftTime then
			self.fields.Text_time:setTimeUpdateListener(function(time)
				self = nil
				;(nil).time = SoraDConvertSecondToString(time)
				self.fields.Text_time:setString(i18n("common_text_766", nil))
			end)
			self.fields.Text_time:beginTime(leftTime)
		end
	end
	if allianceMgr:getAlliance():isRamadanMobiTopAlliance() then
		local leftTime = allianceMgr:getAlliance():getRamadanMobiTopAllianceInfo().endTime - serviceFunctions.systemTime()
		self.fields.Text_time:setVisible(self.selectFlag >= 17 and self.selectFlag <= 20 and 0 < leftTime)
		if 0 < leftTime then
			self.fields.Text_time:setTimeUpdateListener(function(time)
				self = nil
				;(nil).time = SoraDConvertSecondToString(time)
				self.fields.Text_time:setString(i18n("common_text_766", nil))
			end)
			self.fields.Text_time:beginTime(leftTime)
		end
	end
end
function allianceChangeFlagViewPanel:initData()
	self:updateFlag()
	self.tableFlagList = allianceDesRead.getFlagList()
	table.insert(self.tableFlagList, 1, 0)
	table.insert(self.tableFlagList, 1, 0)
	table.insert(self.tableFlagList, 0)
	table.insert(self.tableFlagList, 0)
	self.fields.List:setNumItems(#self.tableFlagList)
end
function allianceChangeFlagViewPanel:updateView(target, data)
	SoraDCloseLoading(self)
	self.curFlag = allianceMgr:getAllianceProperty("flag")
	self.selectFlag = self.curFlag
	self:initData()
	local toIndex = 1
	for k, v in ipairs(self.tableFlagList) do
		if v == self.curFlag then
			toIndex = k
			break
		end
	end
	self.fields.List:scrollToCenter(self.fields.List:getChildAt(toIndex - 1))
end
function allianceChangeFlagViewPanel:btnChangeClickCallBack()
	SoraDPlaySound()
	if not allianceDesRead.checkRank(gAllianceRank.R5) and not allianceDesRead.checkRank(gAllianceRank.R6) then
		SoraDShowMsgBox(i18n("common_text_674"), i18n("common_text_204"))
	elseif SoraDEnoughGold(allianceDesRead.getAllianceFlagPrice(self.selectFlag)) then
		SoraDShowLoading(self)
		allianceSetting:reqModifyFlag(self.selectFlag)
	end
end
function allianceChangeFlagViewPanel:btnCancelClick()
	SoraDPlaySound()
	self:close()
end
return allianceChangeFlagViewPanel
