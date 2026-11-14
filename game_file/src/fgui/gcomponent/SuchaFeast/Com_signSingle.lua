local signReward2022Ctrl = SoraDGetCtrl("signReward2022Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_signSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SuchaFeast/Com_signSingle", Com_signSingle)
function Com_signSingle:onInit()
	self.fields.Text_bq:setString(i18n("common_text_2875"))
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_signSingle:onShow()
end
function Com_signSingle:initData(data)
	self.data = data
	_ENV = nil
	;(nil).count = self.data.day
	self.fields.Text_day:setString(i18n("common_text_523", nil))
	self.fields.item:initData(self.data.normalReward[1], self.data.normalReward[2])
	self.status = signReward2022Ctrl:getSignStatusByDay(self.data.day)
	self.controllers.c1:setSelectedIndex(self.status)
end
function Com_signSingle:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).cfg = self.data
	;(nil).status = self.status
	uiManager:show("SignInfoView", nil)
end
return Com_signSingle
