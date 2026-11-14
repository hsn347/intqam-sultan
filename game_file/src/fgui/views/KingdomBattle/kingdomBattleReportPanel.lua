local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleReportPanel = class("kingdomBattleReportPanel", baseFguiPanel)
_ENV, _UPVALUE2_ = baseFguiPanel, "kingdomBattleReportPanel"
baseFguiPanel.name = "common_text_3155"
_ENV, baseFguiPanel.eventType = nil, 1
;(nil).name = "UID"
;(nil).eventType = 2
;("kingdomBattleReportPanel")[1] = baseFguiPanel
local ("kingdomBattleReportPanel")[2], sortTypeList = nil, "kingdomBattleReportPanel"
function kingdomBattleReportPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleReportPanel:ctor", self.viewName)
	self.times = 0
	self.switcher = false
	self.curSortType = 1
end
function kingdomBattleReportPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleReportPanel:onInit()
	print("=======kingdomBattleReportPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_4149"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self.fields.List_report:setVirtual()
	self.fields.List_report:setItemRenderer(handler(self, self.onReportItemRederer))
	self.fields.Text_name:setString(i18n("common_text_2037"))
	self.fields.Text_noRecord:setString(i18n("common_text_4145"))
	self.c_select = self.fields.Com_choose:getController("c_select")
	local chooseFields = fguiHelper.get_fields(self.fields.Com_choose)
	self.Button_choose = chooseFields.Button_choose
	self.Button_name = chooseFields.Button_name
	self.Button_uid = chooseFields.Button_uid
	self.Button_name:setString(i18n("common_text_3155"))
	self.Button_uid:setString("UID")
	self.Button_choose:addClickListener(handler(self, self.onClickBtnText))
	self.Button_name:addClickListener(handler(self, self.onClickBtnText))
	self.Button_uid:addClickListener(handler(self, self.onClickBtnText))
	self.fields.Text_name:fixPos()
	self.fields.Com_choose:fixPos()
	self.fields.Button_search:fixPos()
	self.fields.Image_input:fixPos()
	self.fields.Text_input:fixPos()
end
function kingdomBattleReportPanel:onShow()
	print("=======kingdomBattleReportPanel:onShow")
	self:setSwitcher()
	self:refreshLeftTime()
end
function kingdomBattleReportPanel:refreshLeftTime(...)
	SoraDCloseLoading(self:displayObject())
	self.times = conquestWarCtrl:getReportLeftTimes()
	_ENV = self:displayObject()
	self:displayObject().num = self.times
	self.fields.Text_leftTime:setString(i18n("common_text_4148", self:displayObject()))
	if self.proxy:judgeCastleLv() then
		self.fields.Text_leftTime:setVisible(true)
	else
		self.fields.Text_leftTime:setVisible(false)
	end
end
function kingdomBattleReportPanel:req4Info(keyName, pid)
	conquestWarCtrl:reqSearch(keyName, pid)
	SoraDShowLoading(self:displayObject())
end
function kingdomBattleReportPanel:initData(target, redata)
	dump(redata, "==kingdomBattleReportPanel:initData==")
	SoraDCloseLoading(self:displayObject())
	if not redata or not redata.data then
		_ENV = redata.data
	end
	self.infoTbl = redata.data
	self.fields.List_report:setNumItems(#self.infoTbl)
	if next(self.infoTbl) then
		self.fields.Text_noRecord:setVisible(false)
	else
		self.fields.Text_noRecord:setString(i18n("common_text_963"))
		self.fields.Text_noRecord:setVisible(true)
	end
end
function kingdomBattleReportPanel:onReportItemRederer(index, obj)
	local data = self.infoTbl[index + 1]
	if not obj.fields then
		obj:fixChildrenPos()
		obj.fields = fguiHelper.get_fields(obj)
		obj.c_state = obj:getController("c_state")
		local Button_report = obj.fields.Button_report
		Button_report:setString(i18n("common_text_1451"))
		Button_report:addClickListener(handler(self, self.onClickBtnReprot))
		Button_report.c_state = obj.c_state
	end
	local Com_head = obj.fields.Com_head
	Com_head:setHeadSprite(data.iconID, data.avatar)
	Com_head:setPlayerID(data.uid)
	local Text_name = obj.fields.Text_name
	if data.abbr then
		_ENV = handler(self, self.onClickBtnReprot)
		handler(self, self.onClickBtnReprot).abbr = data.abbr
		handler(self, self.onClickBtnReprot).name = data.nickName
		Text_name:setString(i18n("common_text_186", handler(self, self.onClickBtnReprot)))
	else
		Text_name:setString(data.nickName)
	end
	local Text_reported = obj.fields.Text_reported
	if data.isReported then
		obj.c_state:setSelectedIndex(1)
		Text_reported:setString(i18n("common_text_4150"))
	elseif data.isBetrayer then
		obj.c_state:setSelectedIndex(1)
		Text_reported:setString(i18n("common_text_4184"))
	else
		obj.c_state:setSelectedIndex(0)
		Text_reported:setString(i18n("common_text_4150"))
	end
	obj.fields.Button_report:setTag(index + 1)
end
function kingdomBattleReportPanel:onClickBtnReprot(EventContext)
	if self.times <= 0 then
		SoraDShowMsgTip(i18n("common_text_4151"))
		return
	end
	if self.proxy:judgeCastleLv(true) then
		local sender = EventContext:getSender()
		local data = self.infoTbl[sender:getTag()]
		conquestWarCtrl:reqReport(data.uid)
		sender.c_state:setSelectedIndex(1)
		SoraDShowLoading(self:displayObject())
	end
end
function kingdomBattleReportPanel:onClickBtnSearch(...)
	SoraDPlaySound()
	local key = string.match(self.fields.Text_input:getText(), "%s*(.-)%s*$")
	local keyLen = string.utf8len(key)
	if keyLen >= SEARCH_MIN_LEN then
		if self.curSortType == 1 then
			self:req4Info(key, nil)
		elseif tonumber(key) then
			self:req4Info(nil, tonumber(key))
		else
			self:initData()
		end
	else
		SoraDShowMsgBox(i18n("common_text_961"), i18n("common_text_054"))
	end
end
function kingdomBattleReportPanel:onClickBtnText(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.Button_choose then
		self.switcher = not self.switcher
	elseif sender == self.Button_name then
		self.switcher = false
		self.curSortType = 1
	elseif sender == self.Button_uid then
		self.switcher = false
		self.curSortType = 2
	end
	self:setSwitcher()
end
function kingdomBattleReportPanel:setSwitcher()
	self.Button_choose:setString(i18n(sortTypeList[self.curSortType].name))
	self.c_select:setSelectedIndex(self.switcher and 1 or 0)
end
function kingdomBattleReportPanel:onClickHelp(...)
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.KINGDOMBATTLE_TRAITOR)
end
return kingdomBattleReportPanel
