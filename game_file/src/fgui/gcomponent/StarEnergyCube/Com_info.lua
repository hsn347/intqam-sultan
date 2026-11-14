local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_info = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_info", Com_info)
_ENV, _ENV = "ui://StarEnergyCube/Com_info", fgui.register_extension
_ENV, fgui.register_extension[1], ("ui://StarEnergyCube/Com_info").des = "ui://StarEnergyCube/Com_info", "ui://StarEnergyCube/Com_info", "Martial_arts_text_15"
_ENV, fgui.register_extension[2], ("ui://StarEnergyCube/Com_info").des = "ui://StarEnergyCube/Com_info", "ui://StarEnergyCube/Com_info", "Martial_arts_text_16"
_ENV, _ENV, fgui.register_extension[3], ("ui://StarEnergyCube/Com_info").des = Com_info, "ui://StarEnergyCube/Com_info", "ui://StarEnergyCube/Com_info", "Martial_arts_text_17"
local config = fgui.register_extension
_ENV, ("ui://StarEnergyCube/Com_info")[1], Com_info.des = Com_info, Com_info, "Martial_arts_text_19"
_ENV, ("ui://StarEnergyCube/Com_info")[2], Com_info.des = Com_info, Com_info, "Martial_arts_text_20"
;("ui://StarEnergyCube/Com_info")[3], Com_info.des = Com_info, "Martial_arts_text_21"
local subConfig = "ui://StarEnergyCube/Com_info"
function Com_info:onInit()
	self.fields.Effect_0:setIsLoop(false)
	self.fields.Effect_1:setIsLoop(false)
	self.fields.Effect_2:setIsLoop(false)
	self.fields.Button_get:setString(i18n("Martial_arts_text_06"))
	self.fields.Text_defend:setString(i18n("star_cube_12"))
	self.fields.Button_get:addClickListener(handler(self, self.onBtnClick))
	self.fields.touch:addClickListener(handler(self, self.onClickShowBtnInfo))
end
function Com_info:initData(index, data, callbackFunc)
	self.fields.Effect_0:playOnce()
	self.fields.Effect_1:playOnce()
	self.fields.Effect_2:playOnce()
	self.index = index
	self.data = data
	self.callbackFunc = callbackFunc
	self:setTag(self.index)
	self.controllers.c1:setSelectedIndex(index - 1)
	self.fields.title:setString(i18n(config[index].des))
	self.fields.Text_value:setString(string.formatnumberthousands(data.fightCapacity))
	local color = data.openTime > 0 and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0)
	self.fields.Button_get:setTitleColor(color)
end
function Com_info:updateGetBtnState(openTime)
	local color = 0 < openTime and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0)
	self.fields.Button_get:setTitleColor(color)
end
function Com_info:onBtnClick()
	SoraDPlaySound()
	self:callbackFunc(self:getTag(), self.data.itemID)
end
function Com_info:onClickShowBtnInfo()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	;(nil).des = subConfig[self.index].des
	;(nil).defendInfo = self.data
	uiManager:show("StarEnergyCubeArmyInfo", nil):setOwnerKey(self)
end
function Com_info:onShow()
end
return Com_info
