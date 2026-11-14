local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ComHelpRecord = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComHelpRecord", ComHelpRecord)
function ComHelpRecord:onInit()
	self.fields.btnVisit:setTitle(i18n("garden_btn_05"))
	self.fields.btnVisit:addClickListener(handler(self, self.onClick_btnVisit))
end
function ComHelpRecord:onShow()
end
function ComHelpRecord:onClick_btnVisit(context)
	SoraDPlaySound()
	manorCityCtrl:reqGardenMapQueryMap(self.data.uid)
end
function ComHelpRecord:initData(data)
	self.data = data
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	_ENV = nil
	;(nil).name = data.nickName
	self.fields.txtDesc:setString(i18n("Socialize_text_08", nil))
	self.fields.txtTime:setString(SoraDConverTimeStr(data.time))
end
return ComHelpRecord
