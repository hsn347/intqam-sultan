local baseComponent = require("fgui.base.baseComponent")
local Com_FP_Dress = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_Dress", Com_FP_Dress)
function Com_FP_Dress:onInit()
	_UPVALUE3_ = nil
	self.poses, (nil)[1] = nil, cc.p(85, 80.5)
	self.poses, (nil)[2] = nil, cc.p(86, 83)
	self.poses, (nil)[3] = nil, cc.p(91, 80.5)
	self.poses, (nil)[4] = nil, cc.p(99, 83.5)
	self.poses, (nil)[5] = nil, cc.p(99, 83.5)
	self.poses, (nil)[6] = nil, cc.p(99, 83.5)
	self:addClickEventListener(handler(self, self.onDressClick))
	self.fields.button_change:addClickEventListener(handler(self, self.onChangeDress))
	self.fields.text_lock:setString(i18n("common_text_2274"))
end
function Com_FP_Dress:onShow()
	self.fields.button_change:setTitle(i18n("exitic_pavillion_text_0071"))
end
function Com_FP_Dress:initData(intimacyCfg, isUnlock, isCurIdx, isSelected)
	self.fields.button_change:setVisible(isUnlock and not isSelected and isCurIdx)
	self.controllers.c1:setSelectedIndex(isUnlock and 0 or 1)
	self.fields.normal:setURL("frame_ygg_yc_0" .. intimacyCfg.intimacy .. ".png")
	self.fields.normal:setColor(isUnlock and cc.c3b(255, 255, 255) or cc.c3b(125, 125, 125))
	self.fields.now:setVisible(isSelected)
	if isCurIdx then
		self.fields.selected:setEffectPath("G_yifu" .. intimacyCfg.intimacy .. ".usm")
		self.fields.selected:setPosition(self.poses[intimacyCfg.intimacy])
		self.fields.selected2:setAllFrameName("dh_yichu_d_%02d.png", 1)
		self.fields.selected2:setPlaySettings(0, -1, -1)
		self.fields.flower:setAllFrameName("dh_yifu_hb_%02d.png", 1)
		self.fields.flower:setPlaySettings(0, -1, -1)
	end
	self.fields.selected:setVisible(isCurIdx and isUnlock)
	self.fields.selected2:setVisible(isCurIdx)
	self.fields.flower:setVisible(isCurIdx)
end
function Com_FP_Dress:setDressClickEvent(callback, param)
	self.dressCallback = callback
	self.dressParam = param
end
function Com_FP_Dress:onDressClick()
	SoraDPlaySound()
	if self.dressCallback then
		self.dressCallback(nil, self.dressParam)
	end
end
function Com_FP_Dress:setChangeClickEvent(callback, param)
	self.changeCallback = callback
	self.changeParam = param
end
function Com_FP_Dress:onChangeDress()
	SoraDPlaySound()
	if self.changeCallback then
		self.changeCallback(nil, self.changeParam)
	end
end
return Com_FP_Dress
