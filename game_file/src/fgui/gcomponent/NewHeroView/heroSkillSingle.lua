local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local heroSkillSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/heroSkillSingle", heroSkillSingle)
fgui.register_extension("ui://NewHeroView/Com_ShowSkillSingle", heroSkillSingle)
function heroSkillSingle:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClick))
	self:addEventListener(fgui.UIEventType.TouchEnd, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_HERODETAIL_SKILLPOP"
		;(nil).isShow = false
		SoraDSendMessage(nil)
	end)
end
function heroSkillSingle:onShow()
end
function heroSkillSingle:initData(data)
	self.skillID = tonumber(data.skillID)
	self.quality = data.quality
	self.otherData = data.otherData
	self.index = data.index
	self:initView()
end
function heroSkillSingle:initView()
	local info = heroltCtrl.getSkillDesInfo(self.skillID)
	self.fields.Image_skillIcon:setSpriteFrame(info.herIcon)
	self.fields.Sprite_skillBg:setSpriteFrame(heroltCtrl.getSkillBg(self.quality))
	if self.fields.Text_lv then
		if self.otherData.skillLv then
			heroltCtrl = heroltCtrl.getSkillBg(self.quality)
			heroltCtrl.getSkillBg(self.quality).lv = self.otherData.skillLv
			self.fields.Text_lv:setString(i18n("common_text_101", heroltCtrl.getSkillBg(self.quality)))
			self.fields.Text_lv:setVisible(not self.otherData.isActive)
		else
			self.fields.Text_lv:setVisible(false)
		end
	end
	self.fields.Sprite_lock:setVisible(not self.otherData.isActive)
	self.fields.n5:setVisible(not self.otherData.isActive)
end
function heroSkillSingle:onLongPress()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_HERODETAIL_SKILLPOP"
	;(nil).skillID = self.skillID
	;(nil).quality = self.quality
	;(nil).otherData = self.otherData
	;(nil).index = self.index
	;(nil).isShow = true
	SoraDSendMessage(nil)
end
function heroSkillSingle:setClickHandBack(handle)
	self.handBack = handle
end
function heroSkillSingle:onClick()
	if self.handBack then
		self.handBack(self.skillID, self.otherData)
	else
		_ENV = self.skillID
		self.skillID.msg = "MESSAGE_UI_HERODETAIL_SKILLPOP"
		self.skillID.isShow = false
		SoraDSendMessage(self.skillID)
	end
end
return heroSkillSingle
