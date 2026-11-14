local baseComponent = require("fgui.base.baseComponent")
local Com_warListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Com_warListSingle", Com_warListSingle)
function Com_warListSingle:onInit()
	self.fields.Button_view_r:addClickListener(handler(self, self.btnRClick))
	self.fields.Button_view_l:addClickListener(handler(self, self.btnLClick))
	self:fixChildrenPos()
end
function Com_warListSingle:onShow()
end
function Com_warListSingle:initData(data)
	self.data = data
	self.fields.Text_name_r:setString(self.data.kidInfo.kName)
	_ENV = nil
	;(nil).num = math.floor(self.data.kidInfo.score)
	self.fields.Text_score_r:setString(i18n("common_text_2556", nil))
	self.fields.Text_name_l:setString(self.data.matchKidInfo.kName)
	_ENV = i18n("common_text_2556", nil)
	i18n("common_text_2556", nil).num = math.floor(self.data.matchKidInfo.score)
	self.fields.Text_score_l:setString(i18n("common_text_2556", i18n("common_text_2556", nil)))
end
function Com_warListSingle:btnRClick()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(cc.p(600, 600), false, self.data.kidInfo.kid)
	SoraDRemoveAllPanelFromManager()
end
function Com_warListSingle:btnLClick()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(cc.p(600, 600), false, self.data.matchKidInfo.kid)
	SoraDRemoveAllPanelFromManager()
end
return Com_warListSingle
