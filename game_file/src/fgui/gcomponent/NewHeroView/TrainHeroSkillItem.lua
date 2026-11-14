local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local TrainHeroSkillItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/TrainHeroSkillItem", TrainHeroSkillItem)
function TrainHeroSkillItem:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function TrainHeroSkillItem:onShow()
end
function TrainHeroSkillItem:initData(data, heroID)
	self.heroID = heroID
	self.skillID = tonumber(data.skillID)
	self.quality = data.quality
	self.otherData = data.otherData
	self.index = data.index
	self:initView()
end
function TrainHeroSkillItem:initView()
	local info = heroltCtrl.getSkillDesInfo(self.skillID)
	self.fields.Image_skillIcon:setSpriteFrame(info.herIcon)
	self.fields.Sprite_skillBg:setSpriteFrame(heroltCtrl.getSkillBg(self.quality))
	self.fields.Text_name:setString(i18n(info.herName))
	self.fields.Sprite_lock:setVisible(not self.otherData.isActive)
	self.fields.n5:setVisible(not self.otherData.isActive)
end
function TrainHeroSkillItem:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).heroID = self.heroID
	;(nil).skillID = self.skillID
	;(nil).quality = self.quality
	;(nil).otherData = self.otherData
	uiManager:show("heroSkillPopView", nil)
end
return TrainHeroSkillItem
