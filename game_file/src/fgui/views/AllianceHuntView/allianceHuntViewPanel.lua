local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceHuntViewPanel = class("allianceHuntViewPanel", baseFguiPanel)
function allianceHuntViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("allianceHuntViewPanel:ctor", self.viewName)
end
function allianceHuntViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceHuntViewPanel:onInit()
	print("=======allianceHuntViewPanel:onInit")
	self.selectIndex = 1
	self.switch = false
	self.node = SoraDGetChildByName(self, "Top_Node")
	self.btnEnter = SoraDGetChildByName(self, "Button_enter")
	self.textRemainNum = SoraDGetChildByName(self, "text_remain_num")
	self.textCurScore = SoraDGetChildByName(self, "text_cur_score")
	self.textMyScore = SoraDGetChildByName(self, "text_my_score")
	self.btnRank = SoraDGetChildByName(self, "btn_rank")
	self.txtOpRank = SoraDGetChildByName(self, "Text_Op_Rank")
	self.btnExchange = SoraDGetChildByName(self, "btn_exchange")
	self.txtOpExchange = SoraDGetChildByName(self, "Text_Op_Exchange")
	self.textDayNum = SoraDGetChildByName(self, "text_day_num")
	self.btnEnter:addClickEventListener(handler(self, self.onClick_btnEnter))
	self.btnRank:addClickEventListener(handler(self, self.onClick_btnRank))
	self.btnExchange:addClickEventListener(handler(self, self.onClick_btnExchange))
	self.node_dropBox = SoraDGetChildByName(self, "node_dropBox")
	self.Button_choose = SoraDGetChildByName(self.node_dropBox, "Button_choose")
	self.ComboBox = SoraDGetChildByName(self, "node_dropBox")
	self.fields.Com_title:initData(i18n("alliance_hunt_btn_02"), handler(self, self.onClickClose), handler(self, self.onClick_btnInfo))
	self.btnEnter:setTitleText(i18n("common_text_4413"))
	self.btnRank:setTitleText(i18n("common_text_851"))
	self.btnExchange:setTitleText(i18n("alliance_hunt_btn_01"))
	self.Panel_Shadow = SoraDGetChildByName(self, "Panel_Shadow")
	self.btnRank:fixPos()
	self.btnExchange:fixPos()
	self:init()
	self.fields.fire1:setAllFrameName("dh_dxtanxian_%02d.png", 1)
	self.fields.fire2:setAllFrameName("dh_dxtanxian_%02d.png", 1)
	self.Panel_Shadow:runAction(ffa.fadeOut(0.6))
	SoraDPlaySound("huntSound", "hunt_into")
end
function allianceHuntViewPanel:onShow()
	print("=======allianceHuntViewPanel:onShow")
	local viewSize = self.view:getSize()
	local scale = math.max(viewSize.height / 1136, viewSize.width / 640, 1)
	self.node:setScale(scale)
end
function allianceHuntViewPanel:init(data)
	self.data = allianceHuntCtrl:getHuntData()
	if not self.data then
		return
	end
	self:updateInfo()
	self:initDropBox()
	self:updateDropBox()
end
function allianceHuntViewPanel:initDropBox()
	local _ENV, tableData
	local self.indexArray, _ENV, _ENV, values
	for i = 1, HUNTING_MAX_TIMES do
		_ENV = nil
		;(nil).count = i
		;(nil).num = i
		table.insert(tableData, i18n("alliance_text_38", nil))
		table.insert(values, i)
	end
	_ENV = nil
	;(nil).items = tableData
	;(nil).values = values
	;(nil).changedCallback = handler(self, self.onChooseClick)
	;(nil).selectedValue = self.selectIndex
	self:setComboBox(self.ComboBox, nil)
	local dropdown = self.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.ComboBox:addClickListener(function()
		SoraDPlaySound()
		local curNum = HUNTING_MAX_TIMES - self.data.challengeTimes
		for i, v in ipairs(self.comboBoxList:getChildren()) do
			v:setTitleColor(curNum >= i and cc.c3b(255, 255, 255) or cc.c3b(125, 125, 125))
		end
		dump(self.selectIndex, "self.selectIndex")
		self.comboBoxList:setSelectedIndex(self.selectIndex - 1)
	end)
end
function allianceHuntViewPanel:onChooseClick(button, event)
	SoraDPlaySound()
	local selectIndex = tonumber(self.ComboBox:getValue())
	local curNum = HUNTING_MAX_TIMES - self.data.challengeTimes
	print(selectIndex, curNum, "selectIndex <= curNum")
	if selectIndex > curNum then
		selectIndex = self.selectIndex
	end
	self.selectIndex = selectIndex
	self:updateDropBox()
end
function allianceHuntViewPanel:updateDropBox()
	self.comboBoxList:setSelectedIndex(self.selectIndex - 1)
	_ENV = nil
	;(nil).count = self.selectIndex
	;(nil).num = self.selectIndex
	self.ComboBox:setTitle(i18n("alliance_text_38", nil))
end
function allianceHuntViewPanel:showDropBox()
end
function allianceHuntViewPanel:updateInfo()
	self.curNum = HUNTING_MAX_TIMES - self.data.challengeTimes
	local totalNum = HUNTING_MAX_TIMES
	local numColor = self.curNum > 0 and "#F1C672" or "#FF0000"
	_ENV = self.curNum
	self.curNum.color = numColor
	local numStr1 = SoraDWrapHtmlTagByStyle(tostring(self.curNum), self.curNum)
	local str = string.format("%s/%s", numStr1, tostring(totalNum))
	_ENV = tostring(totalNum)
	tostring(totalNum).num = str
	self.textRemainNum:setString(i18n("arena_columntext_03", tostring(totalNum)))
	_ENV = i18n("arena_columntext_03", tostring(totalNum))
	i18n("arena_columntext_03", tostring(totalNum)).num = allianceHuntCtrl:getHuntingPoint() or 0
	self.textCurScore:setString(i18n("alliance_hunt_text_04", i18n("arena_columntext_03", tostring(totalNum))))
	_ENV = i18n("alliance_hunt_text_04", i18n("arena_columntext_03", tostring(totalNum)))
	i18n("alliance_hunt_text_04", i18n("arena_columntext_03", tostring(totalNum))).num = self.data.todayHuntingPoint or 0
	self.textMyScore:setString(i18n("alliance_hunt_text_05", i18n("alliance_hunt_text_04", i18n("arena_columntext_03", tostring(totalNum)))))
	if self.curNum == 0 then
		self.btnEnter:setBright(false)
	else
		self.btnEnter:setBright(true)
	end
	self:updateExchangeRedPoint()
end
function allianceHuntViewPanel:msgUpdateExhcangeRedPoint(target, data)
	self:updateExchangeRedPoint()
end
function allianceHuntViewPanel:updateExchangeRedPoint()
	local canExchange = allianceHuntCtrl:hasAnyExchange()
	if canExchange then
		allianceHuntCtrl = nil
		;(nil).byUID = true
		local configTime = SoraDConfigGet("Game:allianceHuntViewPanel:saveTime~integer", nil)
		local nowTime = serviceFunctions.systemTime()
		if os.date("%d", nowTime) ~= os.date("%d", configTime) then
			self.isNeedShowRedPoint = true
			self.btnExchange:setRedVisible(true)
		else
			self.btnExchange:setRedVisible(false)
			self.isNeedShowRedPoint = false
		end
	else
		self.btnExchange:setRedVisible(false)
		self.isNeedShowRedPoint = false
	end
end
function allianceHuntViewPanel:onClick_btnEnter(sender, event)
	SoraDPlaySound()
	local curNum = HUNTING_MAX_TIMES - self.data.challengeTimes
	if curNum <= 0 then
		SoraDShowMsgTip(i18n("alliance_hunt_text_02"))
		return
	end
	local panel = uiManager:show("allianceHuntChallenge").view
	panel:initChallengeTimes(self.selectIndex)
end
function allianceHuntViewPanel:onClick_btnInfo(sender, event)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("alliance_hunt_text_03"))
end
function allianceHuntViewPanel:onClick_btnRank(sender, event)
	SoraDPlaySound()
	uiManager:show("allianceHuntRank")
end
function allianceHuntViewPanel:onClick_btnExchange(sender, event)
	SoraDPlaySound()
	uiManager:show("allianceHuntExchangeView")
	if self.isNeedShowRedPoint then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:allianceHuntViewPanel:saveTime~integer", serviceFunctions.systemTime(), nil)
		self.btnExchange:setRedVisible(false)
	end
end
function allianceHuntViewPanel:sMsgHandlerBattleEnd(target, data)
	self:updateInfo()
	self.selectIndex = 1
	self:initDropBox()
	self:updateDropBox()
end
function allianceHuntViewPanel:sMsgHandlerDailyRefresh(target, data)
	self:updateInfo()
end
function allianceHuntViewPanel:sMsgBuySuccess(target, data)
	self:updateInfo()
end
return allianceHuntViewPanel
