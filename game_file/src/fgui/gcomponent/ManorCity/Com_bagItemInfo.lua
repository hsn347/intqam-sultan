local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_bagItemInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/Com_bagItemInfo", Com_bagItemInfo)
function Com_bagItemInfo:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.onClickBtnUse))
	self.fields.Button_merge:setString(i18n("common_text_1352"))
	self.fields.Button_merge:addClickListener(handler(self, self.onClickBtnMerge))
	self.fields.Button_disass:setString(i18n("common_text_1378"))
	self.fields.Button_disass:addClickListener(handler(self, self.onClickBtnDisass))
end
function Com_bagItemInfo:onShow()
end
function Com_bagItemInfo:onClickBtnUse(context)
	SoraDPlaySound()
end
function Com_bagItemInfo:onClickBtnMerge(context)
	SoraDPlaySound()
	manorCityCtrl:reqDressUpLv(self.data.dressId)
end
function Com_bagItemInfo:onClickBtnDisass(context)
	SoraDPlaySound()
	manorCityCtrl:reqDressDis(self.data.dressId)
end
function Com_bagItemInfo:initData(data)
	dump(data, "==Com_bagItemInfo:initData==")
	self.data = data
	local curPosX = data.curPosX
	self.fields.Image_arr:setPositionX(curPosX)
	local dressId = data.dressId
	local dressName = manorCityRead.getDressName(dressId)
	self.fields.Text_title:setString(dressName)
	local dressDes = manorCityRead.getDressDes(dressId)
	self.fields.Text_des:setString(dressDes)
end
return Com_bagItemInfo
