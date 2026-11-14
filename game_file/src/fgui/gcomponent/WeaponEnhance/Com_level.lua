local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_level = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WeaponEnhance/Com_level", Com_level)
function Com_level:onInit()
	self:fixChildrenPos()
	self.fields.Btn_detail:addClickListener(handler(self, self.onClick))
end
function Com_level:onShow()
end
function Com_level:initData(data, quality)
	self.quality = quality
	self.controllers.c1:setSelectedIndex(data.sType)
	if data.sType == 0 then
		self.lv = data.lv
		self.slv = data.slv
		_ENV = nil
		;(nil).lv = data.lv
		self.fields.Text_des:setString(i18n("strengthen_resonance_3", nil))
		_ENV = i18n("strengthen_resonance_3", nil)
		i18n("strengthen_resonance_3", nil).num1 = data.slv
		i18n("strengthen_resonance_3", nil).num2 = data.nextSlv
		self.fields.Text_slv:setString(i18n("strengthen_resonance_4", i18n("strengthen_resonance_3", nil)))
	elseif data.sType == 1 then
		local buffName = buffDesRead.getTitleBase(data.buffType)
		local buffValue = buffDesRead.getTitleValueWithValue(data.buffType, data.buffVal)
		_ENV = i18n("strengthen_resonance_4", i18n("strengthen_resonance_3", nil))
		i18n("strengthen_resonance_4", i18n("strengthen_resonance_3", nil)).var1 = fguiHelper.getColorString("#B4AA87", buffName)
		i18n("strengthen_resonance_4", i18n("strengthen_resonance_3", nil)).var2 = buffValue
		self.fields.Text_des:setString(i18n("%{var1}:%{var2}", i18n("strengthen_resonance_4", i18n("strengthen_resonance_3", nil))))
	elseif data.sType == 2 then
		self.fields.Text_des:setString(i18n("fortress_text_19"))
	end
end
function Com_level:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).quality = self.quality
	;(nil).lv = self.lv
	;(nil).slv = self.slv
	uiManager:show("WeaponEnhancePopup", nil)
end
return Com_level
