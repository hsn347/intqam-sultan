local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001629_RecvWishPanel = class("Activity_9001629_RecvWishPanel", baseFguiPanel)
local dailyRemindManager = include("dailyRemindManager")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001629_Read = include("activity_9001629_Read")
local activity_9001629_Ctrl = SoraDGetCtrl("activity_9001629_Ctrl")
function Activity_9001629_RecvWishPanel:ctor(...)
	Activity_9001629_RecvWishPanel.super.ctor(self, ...)
	print("Activity_9001629_RecvWishPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001629_RecvWishPanel:onInit()
	print("=======Activity_9001629_RecvWishPanel:onInit")
	self.fields.btn_left:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and 1 or -1)
	self.fields.btn_right:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and -1 or 1)
	self.fields.Check_tick:setSelected(false)
	self.showIndex = 1
	self.fields.Text_remind:setString(i18n("coffeeCraftsman_text_27"))
	self.dataList, _ENV = self.fields.Text_remind.setString, self.fields.Text_remind.setString
	if self.param then
		for i, v in pairs(self.param.dataList) do
			table.insert(self.dataList, v)
		end
	end
	self.fields.Usm_2:setMaxChunkSize(84608)
	self.fields.Check_tick:fixPos()
	self.fields.Text_remind:fixPos()
	self.fields.text_1:fixPos()
	self.fields.text_1_bg:fixPos()
	self.fields.text_2:fixPos()
	self.fields.text_2_bg:fixPos()
	self.fields.text_3:fixPos()
	self.fields.text_3_bg:fixPos()
end
function Activity_9001629_RecvWishPanel:onShow()
	print("=======Activity_9001629_RecvWishPanel:onShow")
	self:updateView()
	activity_9001629_Ctrl:reqRead()
	self.fields.Usm_2:setAlpha(0)
	self.fields.Usm_2:runAction(ffa.fadeIn(0.5))
end
function Activity_9001629_RecvWishPanel:onHide()
	local bCheck = self.fields.Check_tick:isSelected()
	if bCheck then
		dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.activity_9001629)
	end
end
function Activity_9001629_RecvWishPanel:updateView()
	self.data = self.dataList[self.showIndex]
	if self.data == nil then
		return
	end
	dump(self.dataList, "self.dataList")
	activity_9001629_Read = self.dataList
	self.dataList[1] = self.data
	self.dataList[2] = self.showIndex
	dump(self.dataList, "Activity_9001629_RecvWishPanel:updateView")
	_ENV = "Activity_9001629_RecvWishPanel:updateView"
	;("Activity_9001629_RecvWishPanel:updateView").nickName = self.data.name
	;("Activity_9001629_RecvWishPanel:updateView").allianceAbb = self.data.abbr
	;("Activity_9001629_RecvWishPanel:updateView").fromKid = self.data.kid
	local nameStr = lordInfoCtrl:getSplitName("Activity_9001629_RecvWishPanel:updateView")
	_ENV = nil
	_ENV, _ENV, (nil).name = nil, nil, nameStr
	;(nil).size = 28
	;(nil).name, (nil).color = nil, "#FFD43E"
	self.fields.text_tip:setString(i18n_html("nebula_stars_wishing_text25", nil, nil))
	if self.data.texts and not self.data.text then
		self.data.text = self.data.texts
	end
	if not self.data.text then
		_ENV = self.data.text
	end
	self.data.text = self.data.text
	for i = 1, 3 do
		local textIdx = self.data.text[i]
		self.fields["text_" .. i]:setVisible(textIdx ~= nil)
		self.fields["text_" .. i .. "_bg"]:setVisible(textIdx ~= nil)
		if textIdx then
			local textCfg = activity_9001629_Read.getWishingTextList(textIdx)
			self.fields["text_" .. i]:setString(i18n(textCfg.text))
		end
	end
	local isAddEnable = self.dataList[self.showIndex + 1] ~= nil
	local isMinEnable = self.dataList[self.showIndex - 1] ~= nil
	if SoraDFIsRA() then
		self.fields.btn_left:setVisible(isAddEnable)
		self.fields.btn_right:setVisible(isMinEnable)
	else
		self.fields.btn_left:setVisible(isMinEnable)
		self.fields.btn_right:setVisible(isAddEnable)
	end
end
function Activity_9001629_RecvWishPanel:onPageClick(sender, params)
	SoraDPlaySound()
	local curIndex = self.showIndex + params
	if self.dataList[curIndex] == nil then
		if 0 < params then
			curIndex = #self.dataList
		else
			curIndex = 1
		end
	end
	self.showIndex = curIndex
	self:updateView()
end
return Activity_9001629_RecvWishPanel
