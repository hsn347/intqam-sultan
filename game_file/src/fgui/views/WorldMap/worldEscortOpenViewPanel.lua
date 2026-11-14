local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local worldEscortOpenViewPanel = class("worldEscortOpenViewPanel", baseFguiPanel)
function worldEscortOpenViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("worldEscortOpenViewPanel:ctor", self.viewName)
end
function worldEscortOpenViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function worldEscortOpenViewPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
	print("=======worldEscortOpenViewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_2327"))
	self.text_tip = self.fields.text_tip
	self.text_tip:setString(i18n("common_text_2328"))
	self.btn_open = self.fields.btn_open
	self.btn_open:setTitleText(i18n("common_text_2320"))
	self.text_open_tip = self.fields.text_open_tip
	self.text_open_tip:setString(i18n("common_text_2332"))
	self.text_addValue = self.fields.text_addValue
	self.text_addValue:setString(i18n("common_text_2329"))
	self.text_remainTime = self.fields.text_remainTime
	self.text_remainTime:setString(i18n("common_text_2330"))
	self.btn_open:addClickEventListener(handler(self, self.btnOpenClick))
end
function worldEscortOpenViewPanel:onShow()
	print("=======worldEscortOpenViewPanel:onShow")
	self:initWithData()
end
function worldEscortOpenViewPanel:initWithData()
	local alliance = allianceMgr:getAlliance()
	local currentState = alliance:getEscortState()
	if gEscortAddState.CLOSE == currentState then
		self:showCanOpen()
	elseif gEscortAddState.OPENING == currentState then
		self:showOpening()
	elseif gEscortAddState.OPENED == currentState then
		if alliance:getEscortRemainTimes() > 0 then
			self:showCanOpen()
		else
			self:showOpened()
		end
	end
end
function worldEscortOpenViewPanel:showCanOpen()
	self.controllers.c1:setSelectedIndex(0)
	self.text_open_tip:setVisible(false)
	self.btn_open:setVisible(true)
	self.text_tip:setVisible(true)
end
function worldEscortOpenViewPanel:showOpened()
	self.controllers.c1:setSelectedIndex(0)
	self.text_tip:setVisible(true)
	self.btn_open:setVisible(false)
	self.text_open_tip:setVisible(true)
end
function worldEscortOpenViewPanel:showOpening()
	self.controllers.c1:setSelectedIndex(1)
	self.text_tip:setVisible(false)
	self.btn_open:setVisible(false)
	self.text_open_tip:setVisible(false)
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
	local alliance = allianceMgr:getAlliance()
	local addValue = alliance:getEscortAddValue()
	_ENV = handler(self, self.updateTime)
	handler(self, self.updateTime).value = math.floor(addValue * 100)
	self.text_addValue:setString(i18n("common_text_2329", handler(self, self.updateTime)))
end
function worldEscortOpenViewPanel:updateTime()
	local alliance = allianceMgr:getAlliance()
	local remainTime = alliance:getEscortOpeningTime()
	local timeStr = SoraDConvertSecondToString(remainTime)
	allianceMgr = nil
	;(nil).time = timeStr
	self.text_remainTime:setString(i18n("common_text_2330", nil))
end
function worldEscortOpenViewPanel:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:showOpened()
end
function worldEscortOpenViewPanel:btnOpenClick(button, event)
	print("开启加成-----------------------------------")
	SoraDPlaySound()
	SoraDShowLoading(self)
	allianceMgr:reqOpenEscortAdd()
end
function worldEscortOpenViewPanel:sMsgAddSuccess(target, data)
	SoraDCloseLoading(self)
	self:initWithData()
end
function worldEscortOpenViewPanel:sMsgAddFailed(target, data)
	SoraDCloseLoading(self)
end
return worldEscortOpenViewPanel
