local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_TreasureCave_award = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameActivity/Com_TreasureCave_award", Com_TreasureCave_award)
function Com_TreasureCave_award:onInit()
	self.fields.title:setString(i18n("flames_dunes_text133"))
	self.fields.Text_extra:setString(i18n("flames_dunes_text134"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Com_item:getChild("item"):setIcon("icon_9001674_cbd_anniu.png")
	self.fields.Com_item:getChild("item"):setNum(0)
	self.fields.Com_item:addClickListener(handler(self, self.btnExtraClick))
	self:fixChildrenPos()
	self.fields.bg:fix()
end
function Com_TreasureCave_award:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Com_TreasureCave_award:onShow()
end
function Com_TreasureCave_award:initData(leftCount)
	local cfg = roaringFlameWarRead.getCaveRewardCfg(1)
	self.rewardList = cfg[1].rewards
	self.fields.List:setNumItems(#self.rewardList)
	roaringFlameWarRead = nil
	;(nil).val = leftCount
	self.fields.Text_left:setString(i18n("flames_dunes_text135", nil))
end
function Com_TreasureCave_award:btnExtraClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlameTreasureCave_Extra")
end
return Com_TreasureCave_award
