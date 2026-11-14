local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_RecordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_RecordSingle", Com_RecordSingle)
local Title_SIZEH = 50
local Record_SIZEH = 90
local Menu_SIZEH = 50
function Com_RecordSingle:onInit()
	self.fields.list_Options:setItemRenderer(handler(self, self.itemRenderer_list_Options))
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickArrow))
	self.fields.text_optionTitle:setString(i18n("football_betting_text_16"))
	self.fields.text_oddTitle:setString(i18n("football_betting_text_19"))
	self.fields.text_rewardTitle:setString(i18n("football_betting_text_17"))
	self:fixChildrenPos()
end
function Com_RecordSingle:onShow()
end
function Com_RecordSingle:initData(data)
	self.isOpen = false
	self.matchId = data.matchId
	self.titlelist = data.titlelist
	self:updateTitle()
	self:updateRecordList()
	self:updateRedDot()
end
function Com_RecordSingle:updateRecordList()
	local optionsListH = #self.titlelist * Record_SIZEH
	if self.isOpen then
		self.fields.list_Options:setNumItems(#self.titlelist)
		self.fields.list_Options:resizeToFit(#self.titlelist)
		self.fields.img_bg:setHeight(Menu_SIZEH + optionsListH)
		self.controllers.c1:setSelectedIndex(1)
	else
		self.fields.list_Options:setNumItems(0)
		self.controllers.c1:setSelectedIndex(0)
	end
	self:setHeight(self.isOpen and Title_SIZEH + Menu_SIZEH + optionsListH or Title_SIZEH)
	self.fields.Sprite_arr:setRotation(self.isOpen and 0 or SoraDFPosX(90, 0))
end
function Com_RecordSingle:updateTitle()
	local isDaily = activity_9001734_Ctrl:isDailyMatch(self.matchId)
	local matchData = activity_9001734_Ctrl:getMatchData(self.matchId)
	if isDaily then
		local config1 = activity_9001734_Read.getCountryCfg(matchData.team1)
		local config2 = activity_9001734_Read.getCountryCfg(matchData.team2)
		local titleStr = i18n(config1.country) .. " VS " .. i18n(config2.country)
		self.fields.UI_Lab_title:setString(titleStr)
	else
		self.fields.UI_Lab_title:setString(i18n("football_betting_text_03"))
	end
end
function Com_RecordSingle:updateRedDot()
	self.fields.Label_reddot:initData(activity_9001734_Ctrl:isRecordMatchNeedRed(self.matchId))
end
function Com_RecordSingle:itemRenderer_list_Options(index, obj)
	local title = self.titlelist[index + 1]
	obj:initData(self.matchId, title)
end
function Com_RecordSingle:btnClickArrow()
	SoraDPlaySound()
	self.isOpen = not self.isOpen
	self:updateRecordList()
	activity_9001734_Ctrl:setReadRecordNum(self.matchId)
	_ENV = activity_9001734_Ctrl
	activity_9001734_Ctrl.msg = "MESSAGE_ACTIVITY_9001734_RECORD"
	SoraDSendMessage(activity_9001734_Ctrl)
	self:updateRedDot()
end
return Com_RecordSingle
