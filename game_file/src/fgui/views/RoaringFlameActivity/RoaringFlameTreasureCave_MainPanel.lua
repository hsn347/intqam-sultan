local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameTreasureCave_MainPanel = class("RoaringFlameTreasureCave_MainPanel", baseFguiPanel)
function RoaringFlameTreasureCave_MainPanel:ctor(...)
	self.isLRU = true
	RoaringFlameTreasureCave_MainPanel.super.ctor(self, ...)
	print("RoaringFlameTreasureCave_MainPanel:ctor", self.viewName)
end
function RoaringFlameTreasureCave_MainPanel:onInit()
	print("=======RoaringFlameTreasureCave_MainPanel:onInit")
	local itemCfg = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_CAVE_ITEM")
	self.caveWeekTimes = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CAVE_WEEK_TIMES", 5)
	self.itemID = itemCfg[1]
	self.itemNum = itemCfg[2]
	self.fields.Com_title:initData(i18n("flames_dunes_text131"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("flames_dunes_text132"))
	self.fields.Text_none:setString(i18n("flames_dunes_text138"))
	self.fields.Text_none:setVisible(false)
	self.fields.List_cave:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_go:setString(i18n("flames_dunes_text147"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Com_have:setAddCallBack(handler(self, self.onClickAdd))
end
function RoaringFlameTreasureCave_MainPanel:onItemRenderer(index, obj)
	obj:initData(self.showCaveList[index + 1], self.tag == 2)
end
function RoaringFlameTreasureCave_MainPanel:endShow()
	print("=======RoaringFlameTreasureCave_MainPanel:endShow")
	self.caveList, _ENV = print, print
	self.leftReceiveCaveCount = self.caveWeekTimes
	roaringFlameWarCtrl:reqCampCaveList()
	roaringFlameWarCtrl:reqCaveData()
	self.isInit = true
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("flames_dunes_text136")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("flames_dunes_text137")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_TabW:initView(nil)
	_ENV = nil
	;(nil).byUID = true
	self.isIgnore = SoraDConfigGet("Game:RoaringFlame_notice:cbd~bool", nil) or false
	self.fields.Com_skip_notice:initData(self.isIgnore, i18n("common_text_2273"), handler(self, self.onClickNotice))
end
function RoaringFlameTreasureCave_MainPanel:onClickNotice(ret)
	self.isIgnore = ret
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:RoaringFlame_notice:cbd~bool", self.isIgnore, nil)
	_ENV = "Game:RoaringFlame_notice:cbd~bool"
	;("Game:RoaringFlame_notice:cbd~bool").msg = "MESSAGE_ROARINGFLAMEWAR_ACTIVITY_RED"
	SoraDSendMessage("Game:RoaringFlame_notice:cbd~bool")
end
function RoaringFlameTreasureCave_MainPanel:onTabClick(tag)
	self.tag = tag
	if self.isInit then
		self.isInit = false
	else
		self:updateCaveShow()
	end
end
function RoaringFlameTreasureCave_MainPanel:initView(target, data)
	if data and data.key == "list" then
		if not data.caveList then
			backpackCtrl = data.caveList
		end
		self.caveList = data.caveList
		self:updateCaveShow()
	elseif data and data.key == "data" then
		self.leftReceiveCaveCount = self.caveWeekTimes - (data.receiveCaveCount or 0)
		self.fields.Com_award:initData(self.leftReceiveCaveCount)
	end
	self.fields.Com_have:initData(self.itemID)
	self.fields.Button_go:setReddot(backpackCtrl:getItemCount(self.itemID) >= self.itemNum and self.leftReceiveCaveCount > 0)
end
function RoaringFlameTreasureCave_MainPanel:updateCaveShow()
	self.showCaveList, _ENV = nil, nil
	local isOwnSelf = false
	for k, v in ipairs(self.caveList) do
		if v.uid == SoraDGetPlayerID() then
			isOwnSelf = true
			break
		end
	end
	_ENV = (for generator)
	ipairs(self.caveList)[1] = #self.caveList > 0
	local ipairs(self.caveList)[2], showRed = isOwnSelf, ipairs(self.caveList)
	if self.tag == 2 then
		for k, v in ipairs(self.caveList) do
			if v.uid == SoraDGetPlayerID() then
				table.insert(self.showCaveList, v)
			end
		end
	elseif self.tag == 1 then
		for k, v in ipairs(self.caveList) do
			table.insert(self.showCaveList, v)
		end
	end
	self.fields.List_cave:setNumItems(#self.showCaveList)
	self.fields.Text_none:setVisible(#self.showCaveList == 0)
	for i = 1, 2 do
		self.fields.com_TabW:setBtnRedDot(i, showRed[i])
	end
end
function RoaringFlameTreasureCave_MainPanel:onClickAdd()
	SoraDPlaySound()
	uiManager:show("RoaringFlameTurntable_Main")
end
function RoaringFlameTreasureCave_MainPanel:btnGoClick()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) < self.itemNum then
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("common_text_1806", nil))
		return
	end
	if not worldMapDefine.isInRoaringFlame() then
		SoraDShowMsgTip(i18n("brightWar_text_79"))
		return
	end
	roaringFlameWarCtrl:reqCreateCave()
end
function RoaringFlameTreasureCave_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule21")
	;(nil).content = i18n("flames_dunes_second_rule22")
	uiManager:show("RuleView", nil)
end
return RoaringFlameTreasureCave_MainPanel
