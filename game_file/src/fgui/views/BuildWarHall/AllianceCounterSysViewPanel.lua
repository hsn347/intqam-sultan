local allianceCounterSysCtrl = SoraDGetCtrl("allianceCounterSysCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceCounterSysViewPanel = class("AllianceCounterSysViewPanel", baseFguiPanel)
AllianceCounterSysViewPanel.alliance = 1
AllianceCounterSysViewPanel.own = 2
function AllianceCounterSysViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AllianceCounterSysViewPanel:ctor", self.viewName)
end
function AllianceCounterSysViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceCounterSysViewPanel:onInit()
	print("=======AllianceCounterSysViewPanel:onInit")
	self.fightData, _ENV = print, print
	self.curTab = AllianceCounterSysViewPanel.alliance
	self.fields.Com_title:initData(i18n("CounterSystem_btn_01"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.fields.scroll:setVirtual()
	self.fields.scroll:setItemRenderer(handler(self, self.refreshSingle))
	self.fields.labelNotice:setString(i18n("common_text_1464"))
	self.fields.labelNotice:setVisible(false)
	self.fields.btnJoin:setTitle(i18n("common_text_167"))
	self.fields.btnJoin:addClickEventListener(handler(self, self.btnJoinClickCallBack))
	self.fields.btnJoin:setVisible(false)
	allianceCounterSysCtrl:getUpdateList()
	_ENV = allianceCounterSysCtrl.getUpdateList
	_ENV, _ENV, allianceCounterSysCtrl.getUpdateList.defaultClick = false, allianceCounterSysCtrl, 1
	;(false).title = i18n("CounterSystem_btn_05")
	_ENV, allianceCounterSysCtrl[1], (false).tag = false, false, 1
	;(false).title = i18n("CounterSystem_btn_06")
	allianceCounterSysCtrl.getUpdateList.tabsetArray, allianceCounterSysCtrl[2], (false).tag = allianceCounterSysCtrl, false, 2
	local allianceCounterSysCtrl.getUpdateList.callback, param = handler(self, self.OnBtnChangeClick), allianceCounterSysCtrl.getUpdateList
	self.fields.nodeTab:initView(param)
	self.fields.nodeTab:setBtnRedDot(1, allianceCounterSysCtrl:getNewPoint() > 0)
end
function AllianceCounterSysViewPanel:onShow()
	print("=======AllianceCounterSysViewPanel:onShow")
end
function AllianceCounterSysViewPanel:onRefresh(target, data)
	if self.curTab == AllianceCounterSysViewPanel.own then
		self:getTabData_2()
	end
	SoraDCloseLoading()
end
function AllianceCounterSysViewPanel:onUpdatePoint(target, data)
	if data.type == GREEN_POINT_NOTICE_TYPE.COUNTER_SYS then
		self.fightData[1] = allianceCounterSysCtrl:getAllianceList()
		if self.curTab == AllianceCounterSysViewPanel.alliance then
			if data.justPoint == nil then
				self:updateScrollSize()
			end
			self.fields.nodeTab:setBtnRedDot(1, allianceCounterSysCtrl:getNewPoint() > 0)
		end
	end
	SoraDCloseLoading()
end
function AllianceCounterSysViewPanel:tabChange(tag)
	self.fields.nodeTab:setTabByTag(tag, true)
end
function AllianceCounterSysViewPanel:refreshSingle(index, obj)
	local data = self.fightData[self.curTab][index + 1]
	obj:initData(data, self.curTab, index + 1)
end
function AllianceCounterSysViewPanel:initData()
	self.fightData, _UPVALUE0_ = nil, nil
end
function AllianceCounterSysViewPanel:OnBtnChangeClick(tag)
	self.curTab = tag
	self:updateTab()
end
function AllianceCounterSysViewPanel:updateTab()
	if self.fightData[self.curTab] == nil then
		self["getTabData_" .. self.curTab](self)
	else
		self:updateScrollSize()
	end
	if self.curTab == AllianceCounterSysViewPanel.alliance and allianceMgr:hasJoinAlliance() == nil then
		self.fields.labelNotice:setString(i18n("common_text_583"))
		self.fields.btnJoin:setVisible(true)
	else
		self.fields.labelNotice:setString(self.curTab == AllianceCounterSysViewPanel.own and i18n("CounterSystem_text_35") or i18n("common_text_1464"))
		self.fields.btnJoin:setVisible(false)
	end
end
function AllianceCounterSysViewPanel:btnJoinClickCallBack(button, type)
	SoraDPlaySound()
	uiManager:show("AllianceJoinView")
	self:close()
end
function AllianceCounterSysViewPanel:updateScrollSize()
	self.fields.scroll:setNumItems(#self.fightData[self.curTab])
	self.fields.labelNotice:setVisible(#self.fightData[self.curTab] <= 0)
	self:stopAllActions()
	_UPVALUE1_ = self.curTab
	self.curTab[1] = ffa.delay(0.016666666666666666)
	self.curTab[2] = ffa.callFunc(function()
		self:updateGuideAcion()
	end)
	self.curTab[3] = ffa.callFunc(function()
		self:updateGuideAcion()
	end)
	self:runAction(ffa.seq(self.curTab))
end
function AllianceCounterSysViewPanel:updateGuideAcion()
	if SoraDConfigGet("Game:Guide:allianceCounterSys~bool") and self.curTab == AllianceCounterSysViewPanel.own and #self.fightData[self.curTab] > 0 then
		if self.fingerNode == nil then
			self.fingerNode = SoraDFingerAction()
			self.fields.fingerLoader:setContent(self.fingerNode)
			self.fingerNode:setPosition(self.view:getSize().width / 2, self.view:getSize().height - 210)
			if not SoraDFIsRA() then
				AllianceCounterSysViewPanel = self.view
				self.view[1] = cca.callFunc(function(...)
					self.fingerNode:setPositionX(self.view:getSize().width / 2 + 200)
				end)
				self.view[2] = cca.moveBy(2, -400, 0)
				self.view[3] = cca.moveBy(2, -400, 0)
				self.view[4] = cca.moveBy(2, -400, 0)
				self.view[5] = cca.moveBy(2, -400, 0)
				self.fingerNode:runAction(cca.repeatForever(cca.seq(self.view)))
			else
				AllianceCounterSysViewPanel = cca.repeatForever(cca.seq(self.view))
				cca.repeatForever(cca.seq(self.view))[1] = cca.callFunc(function(...)
					self.fingerNode:setPositionX(self.view:getSize().width / 2 - 200)
				end)
				cca.repeatForever(cca.seq(self.view))[2] = cca.moveBy(2, 400, 0)
				cca.repeatForever(cca.seq(self.view))[3] = cca.moveBy(2, 400, 0)
				cca.repeatForever(cca.seq(self.view))[4] = cca.moveBy(2, 400, 0)
				cca.repeatForever(cca.seq(self.view))[5] = cca.moveBy(2, 400, 0)
				self.fingerNode:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(self.view)))))
			end
		end
		self.fingerNode:setVisible(true)
	elseif self.fingerNode then
		self.fingerNode:setVisible(false)
	end
end
function AllianceCounterSysViewPanel:getTabData_1(...)
	self.fightData[1] = allianceCounterSysCtrl:getAllianceList()
	self:updateScrollSize()
end
function AllianceCounterSysViewPanel:getTabData_2(...)
	local ret = allianceCounterSysCtrl:getOwnList(self.fightData[2] == nil)
	if ret then
		self.fightData[2] = ret
		self:updateScrollSize()
	else
		SoraDShowLoading()
	end
end
function AllianceCounterSysViewPanel:btnHelpClickCallBack(button, type)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("CounterSystem_text_21"))
end
function AllianceCounterSysViewPanel:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:close()
	end
end
function AllianceCounterSysViewPanel:onHide()
	allianceCounterSysCtrl:readNewPoint()
end
return AllianceCounterSysViewPanel
