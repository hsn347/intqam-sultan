local baseComponent = require("fgui.base.baseComponent")
local gameBlockedUsersSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/gameBlockedUsersSingle", gameBlockedUsersSingle)
function gameBlockedUsersSingle:onInit()
	self:fixChildrenPos()
	self.fields.Button_unlock:setString(i18n("common_text_077"))
	self.fields.Button_unlock:addClickListener(handler(self, self.btnUnlockClick))
end
function gameBlockedUsersSingle:onShow()
end
function gameBlockedUsersSingle:initData(singleData)
	self.singleData = singleData
	self.fields.Text_name:setString(self.singleData.name)
	self.fields.Text_power:setString(self.singleData.power)
	self.fields.Com_Head:setHeadSprite(self.singleData.head, self.singleData.avatar)
	if self.singleData.uid then
		self.fields.Com_Head:setPlayerID(self.singleData.uid)
	end
end
function gameBlockedUsersSingle:setHandler(handl)
	self.callBack = handl
end
function gameBlockedUsersSingle:btnUnlockClick()
	SoraDPlaySound()
	if self.callBack then
		self.callBack(self.singleData.uid)
	end
end
return gameBlockedUsersSingle
