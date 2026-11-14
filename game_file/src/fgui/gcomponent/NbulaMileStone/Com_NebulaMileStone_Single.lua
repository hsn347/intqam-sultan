local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaMileStone_Single = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NbulaMileStone/Com_NebulaMileStone_Single", Com_NebulaMileStone_Single)
local nebulaMileStoneRead = include("nebulaMileStoneRead")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
function Com_NebulaMileStone_Single:onInit()
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self:addClickEventListener(handler(self, self.onClicked))
end
function Com_NebulaMileStone_Single:onShow()
end
function Com_NebulaMileStone_Single:initData(chapter, index)
	_ENV = nil
	;(nil).num = chapter.chapter
	self.fields.text_chapter:setString(i18n("common_text_3162", nil))
	self.fields.title:setString(i18n(chapter.chaptername))
	self.fields.icon:setURL("framer_lcb_" .. chapter.chapter .. ".png")
	self.index = chapter.chapter
	self.configs = nebulaMileStoneRead.getConfigs(chapter.chapter)
	local status = "locked"
	local alltime = 0
	for i, v in ipairs(self.configs) do
		local data = nebulaMileStoneCtrl:getTaskData(v.milestoneID)
		if data and data.status == "begin" then
			status = "begin"
			alltime = alltime + data.end_timestamp
		elseif data and data.status == "end" and status ~= "begin" then
			status = "end"
		end
		if data == nil or data.status == "prepare" then
			alltime = alltime + v.duration
		end
	end
	self.status = status
	self.fields.text_time:setVisible(status == "begin")
	if status == "begin" then
		self.fields.text_time:beginTime(alltime - serviceFunctions.systemTime())
	end
	if status == "locked" then
		self.fields.text_status2:setString(i18n("common_text_699"))
	elseif status == "end" then
		self.fields.text_status:setColor(cc.c3b(77, 230, 26))
		self.fields.text_status:setString(i18n("Anchor_text_21"))
	else
		self.fields.text_status:setColor(cc.c3b(77, 230, 26))
		self.fields.text_status:setString(i18n("activity_text_05"))
	end
	self.controllers.c1:setSelectedIndex(status == "locked" and 1 or 0)
end
function Com_NebulaMileStone_Single:setClickHandler(handler)
	self.handler = handler
end
function Com_NebulaMileStone_Single:onClicked()
	if self.status == "locked" then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("nebula_war_text_0309"))
		return
	end
	SoraDPlaySound()
	if self.handler then
		self.handler(self.index)
	end
end
return Com_NebulaMileStone_Single
