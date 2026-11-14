local baseComponent = require("fgui.base.baseComponent")
local gameFanActivitiesSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/gameFanActivitiesSingle", gameFanActivitiesSingle)
function gameFanActivitiesSingle:onInit()
	self:fixChildrenPos()
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
end
function gameFanActivitiesSingle:onShow()
end
function gameFanActivitiesSingle:initData(singleData)
	self.singleData = singleData
	self.fields.Text_title:setString(self.singleData.linkTitle)
	self.fields.Sprite_icon:setSpriteFrame(self.singleData.linkIcon)
end
function gameFanActivitiesSingle:btnGoClick()
	SoraDPlaySound()
	if self.singleData.openFun then
		if "string" == type(self.singleData.openFun) then
			device.openURL(self.singleData.openFun)
		elseif "function" == type(self.singleData.openFun) then
			self.singleData.openFun()
		end
	end
end
return gameFanActivitiesSingle
