local radiantDecreeRead = include("radiantDecreeRead")
local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeBuffPreview = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RadiantDecree/Com_decreeBuffPreview", Com_decreeBuffPreview)
_UPVALUE4_, Com_decreeBuffPreview.onInit = function(self)
	self.fields.Text_1:setString(i18n("recharge_label_022"))
	self.fields.Text_1:fixPos()
	self.fields.Buff_Item1:fixPos()
	self.fields.Buff_Item2:fixPos()
	self.fields.Buff_Item3:fixPos()
	self.fields.Buff_Item4:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.n19:fixPos()
	self.fields.n20:fixPos()
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(1)
end, function(self)
	self.fields.Text_1:setString(i18n("recharge_label_022"))
	self.fields.Text_1:fixPos()
	self.fields.Buff_Item1:fixPos()
	self.fields.Buff_Item2:fixPos()
	self.fields.Buff_Item3:fixPos()
	self.fields.Buff_Item4:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.n19:fixPos()
	self.fields.n20:fixPos()
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(1)
end
_UPVALUE4_, (function(self)
	self.fields.Text_1:setString(i18n("recharge_label_022"))
	self.fields.Text_1:fixPos()
	self.fields.Buff_Item1:fixPos()
	self.fields.Buff_Item2:fixPos()
	self.fields.Buff_Item3:fixPos()
	self.fields.Buff_Item4:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.n19:fixPos()
	self.fields.n20:fixPos()
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(1)
end)[1] = "GloriousDecree_23", "GloriousDecree_23"
_UPVALUE4_, (function(self)
	self.fields.Text_1:setString(i18n("recharge_label_022"))
	self.fields.Text_1:fixPos()
	self.fields.Buff_Item1:fixPos()
	self.fields.Buff_Item2:fixPos()
	self.fields.Buff_Item3:fixPos()
	self.fields.Buff_Item4:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.n19:fixPos()
	self.fields.n20:fixPos()
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(1)
end)[2] = "GloriousDecree_23", "GloriousDecree_22"
_UPVALUE4_, (function(self)
	self.fields.Text_1:setString(i18n("recharge_label_022"))
	self.fields.Text_1:fixPos()
	self.fields.Buff_Item1:fixPos()
	self.fields.Buff_Item2:fixPos()
	self.fields.Buff_Item3:fixPos()
	self.fields.Buff_Item4:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.n19:fixPos()
	self.fields.n20:fixPos()
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(1)
end)[3] = "GloriousDecree_23", "GloriousDecree_19"
local _UPVALUE4_, (function(self)
	self.fields.Text_1:setString(i18n("recharge_label_022"))
	self.fields.Text_1:fixPos()
	self.fields.Buff_Item1:fixPos()
	self.fields.Buff_Item2:fixPos()
	self.fields.Buff_Item3:fixPos()
	self.fields.Buff_Item4:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.n19:fixPos()
	self.fields.n20:fixPos()
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(1)
end)[4], buffTip = "GloriousDecree_23", "GloriousDecree_18", function(self)
	self.fields.Text_1:setString(i18n("recharge_label_022"))
	self.fields.Text_1:fixPos()
	self.fields.Buff_Item1:fixPos()
	self.fields.Buff_Item2:fixPos()
	self.fields.Buff_Item3:fixPos()
	self.fields.Buff_Item4:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.n19:fixPos()
	self.fields.n20:fixPos()
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(1)
end
;("GloriousDecree_23")[1] = "GloriousDecree_27"
;("GloriousDecree_23")[2] = "GloriousDecree_26"
;("GloriousDecree_23")[3] = "GloriousDecree_25"
local ("GloriousDecree_23")[4], braveBuffTip = "GloriousDecree_24", "GloriousDecree_23"
function Com_decreeBuffPreview:initData(tag)
	self.showStatue = tag == 2 and true or false
	local effectInfo, buffBtnTip = radiantDecreeRead.getLastNowEffectInfo(), buffTip
	if self.showStatue then
		self.fields.Text_1:setString(i18n("Soldiers_armor_text_48"))
		effectInfo, buffBtnTip = radiantDecreeRead.getLastNowStatueEffectInfo(), braveBuffTip
	else
		self.fields.Text_1:setString(i18n("recharge_label_022"))
	end
	self.fields.Buff_Item1:initData(effectInfo.EffectIcon[1] .. ".png", buffBtnTip[1])
	self.fields.Buff_Item2:initData(effectInfo.EffectIcon[2] .. ".png", buffBtnTip[2])
	self.fields.Buff_Item3:initData(effectInfo.EffectIcon[3] .. ".png", buffBtnTip[3])
	self.fields.Buff_Item4:initData(effectInfo.EffectIcon[4] .. ".png", buffBtnTip[4])
	self.buffList = radiantDecreeRead.getBuffList(self.showStatue)
	self.fields.Scroll_Buff:setNumItems(#self.buffList)
	dump(radiantDecreeCtrl:getActivityData().statueLevel, "fjkdjfkdjfk")
	if self.showStatue then
		if radiantDecreeCtrl:getActivityData().statueLevel > 0 then
			self.fields.Scroll_Buff:getChildAt(radiantDecreeRead.getNowStatueEffectIndex() - 1):setCurLvState(true)
		end
	else
		self.fields.Scroll_Buff:getChildAt(radiantDecreeRead.getNowEffectIndex() - 1):setCurLvState(true)
	end
	self.fields.Scroll_Buff:resizeToFit(#self.buffList)
	self.curLv = SoraDGetBuildStarLv()
end
function Com_decreeBuffPreview:onItemRenderer(index, target)
	if self.showStatue then
		local lvMin = self.buffList[index] ~= nil and self.buffList[index].BraveLv + 1 or radiantDecreeCtrl:getLimitMinLevel()
		local lvMax = self.buffList[index + 1].BraveLv
		target:initData(lvMin, lvMax, self.buffList[index + 1].PrivilegeEffect, index, self.showStatue)
	else
		local lvMin = self.buffList[index] ~= nil and self.buffList[index].CastleLv + 1 or radiantDecreeCtrl:getLimitMinLevel()
		local lvMax = self.buffList[index + 1].CastleLv
		target:initData(lvMin, lvMax, self.buffList[index + 1].PrivilegeEffect, index, self.showStatue)
	end
end
function Com_decreeBuffPreview:onShow()
end
return Com_decreeBuffPreview
