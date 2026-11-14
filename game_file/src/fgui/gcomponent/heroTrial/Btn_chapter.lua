local heroTrialltCtrl = include("heroTrialltCtrl")
local htMapMgr = include("htMapMgr")
local baseComponent = require("fgui.base.baseComponent")
local Btn_chapter = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://heroTrial/Btn_chapter", Btn_chapter)
function Btn_chapter:onInit()
	self.fields.select:setVisible(false)
	self.fields.pass:setVisible(false)
	self.fields.shadow:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_chapter:onShow()
end
function Btn_chapter:initData(index, curAreaId)
	self.areaId = index
	self.curAreaId = curAreaId
	self.fields.icon:setSpriteFrame(string.format("frame_herotrial_chapter_%.2d.png", index))
	_ENV = string.format("frame_herotrial_chapter_%.2d.png", index)
	string.format("frame_herotrial_chapter_%.2d.png", index).num = self.areaId
	self.fields.title:setString(i18n("common_text_3162", string.format("frame_herotrial_chapter_%.2d.png", index)))
	self.fields.select:setVisible(self.areaId == self.curAreaId)
	self.fields.shadow:setVisible(not htMapMgr.isAreaUnlock(self.areaId))
	self.fields.pass:setVisible(htMapMgr.isAreaPass(self.areaId))
end
function Btn_chapter:btnClick()
	SoraDPlaySound()
	if self.areaId > heroTrialltCtrl.getMaxArea() then
		SoraDShowMsgTip(i18n("common_text_2695"))
	elseif self.areaId ~= self.curAreaId then
		_ENV = self.curAreaId
		self.curAreaId.msg = "MESSAGE_UI_HEROTRIAL_AREA_SELECT"
		self.curAreaId.areaId = self.areaId
		SoraDSendMessage(self.curAreaId)
	end
end
return Btn_chapter
