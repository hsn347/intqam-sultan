local publicRead = include("publicRead")
local activityCommonMergeCtrl = SoraDGetCtrl("activityCommonMergeCtrl")
local activityCommonMergeRead = include("activityCommonMergeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_exchange = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001663/Com_exchange", Com_exchange)
function Com_exchange:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE", handler(self, self.onMsgUpdateList))
end
function Com_exchange:onInit()
	print("==Com_exchange:onInit==", self.activityID)
	self.fields.Lab_mine:setString(i18n("bubble_party_text_06"))
	self.fields.Lab_list:setString(i18n("bubble_party_text_16"))
	self.fields.Text_none:setString(i18n("bubble_party_text_33"))
	self.fields.Text_none:setVisible(false)
	self.fields.List_post:setVirtual()
	self.fields.List_post:setItemRenderer(handler(self, self.onPostRenderer))
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curFormula - 1)
	end)
	self.fields.ComboBox:fixChildrenPos()
end
function Com_exchange:onShow()
end
function Com_exchange:onPostRenderer(index, obj)
	obj:setActivityID(self.activityID)
	obj:initData(self.postList[index + 1])
end
function Com_exchange:setActivityID(activityID, panel)
	self.activityID = activityID
	self.curFormula = 1
	activityCommonMergeRead, self.formulaList = activityCommonMergeRead.getCfgFormula(self.activityID), activityCommonMergeRead.getCfgFormula(self.activityID)
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[1] = i18n("bubble_party_text_17")
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[2] = i18n("bubble_party_text_17")
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[3] = i18n("bubble_party_text_17")
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[4] = i18n("bubble_party_text_17")
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[5] = i18n("bubble_party_text_17")
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[6] = i18n("bubble_party_text_17")
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[7] = i18n("bubble_party_text_17")
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[8] = i18n("bubble_party_text_17")
	_ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[9] = i18n("bubble_party_text_17")
	local _ENV, activityCommonMergeRead.getCfgFormula(self.activityID)[10], items = i18n("bubble_party_text_17")
	local i18n("bubble_party_text_17")[1], values = 1, i18n("bubble_party_text_17")
	for k, v in ipairs(self.formulaList) do
		table.insert(items, publicRead.getName(v))
		table.insert(values, k + 1)
	end
	activityCommonMergeRead = i18n("bubble_party_text_17")
	i18n("bubble_party_text_17").items = items
	i18n("bubble_party_text_17").values = values
	i18n("bubble_party_text_17").changedCallback = handler(self, self.onComboBoxClick)
	panel:setComboBox(self.fields.ComboBox, i18n("bubble_party_text_17"))
	self.fields.Com_post:setActivityID(self.activityID)
end
function Com_exchange:onComboBoxClick()
	SoraDPlaySound()
	self.curFormula = tonumber(self.fields.ComboBox:getValue())
	print("self.curFormula===", self.curFormula)
	self:sortPost()
end
function Com_exchange:updateView(...)
	self.fields.Com_post:initData()
	activityCommonMergeCtrl:reqExchangeList(self.activityID)
end
function Com_exchange:onMsgUpdateList(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	if event.subMsg ~= "exchangeList" then
		return
	end
	if not event.list then
		_UPVALUE0_ = event.list
	end
	self.postSerList = event.list
	self:sortPost()
end
function Com_exchange:sortPost()
	local need = self.formulaList[self.curFormula - 1]
	self.postList, _ENV = self.curFormula - 1, self.curFormula - 1
	for k, v in ipairs(self.postSerList) do
		if v.uid ~= SoraDGetPlayerID() and (need and v.post.offer == need or need == nil) then
			table.insert(self.postList, v)
		end
	end
	table.sort(self.postList, function(a, b)
		return a.post.t < b.post.t
	end)
	self.fields.List_post:setNumItems(#self.postList)
	self.fields.Text_none:setVisible(#self.postList == 0)
end
return Com_exchange
