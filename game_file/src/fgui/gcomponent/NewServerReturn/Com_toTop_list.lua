local backToTopCtrl = SoraDGetCtrl("backToTopCtrl")
local backToTopRead = include("backToTopRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_toTop_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_toTop_list", Com_toTop_list)
function Com_toTop_list:onInit()
	self.fields.List_normal:setItemRenderer(handler(self, self.onItem1Render))
	self.fields.List_top:setItemRenderer(handler(self, self.onItem2Render))
	self.fields.List_extra:setItemRenderer(handler(self, self.onItem3Render))
	self:fixChildrenPos()
	self.fields.n58:fix()
	self.fields.n14:fix()
end
function Com_toTop_list:onItem1Render(index, obj)
	obj:initData(self.normalData[index + 1].id, self.normalData[index + 1].count)
	local isReward = self.data.lv <= self.curLv and self.data.lv > backToTopCtrl:getRewardLv()
	obj:setEffectShow(isReward)
	if self.data.lv > self.curLv then
		obj:setItemStatus(0)
	end
	if self.data.lv <= backToTopCtrl:getRewardLv() then
		obj:setItemStatus(2)
	end
end
function Com_toTop_list:onItem2Render(index, obj)
	obj:initData(self.topData[index + 1].id, self.topData[index + 1].count)
	if backToTopCtrl:isUnLockTop() then
		local isReward = self.data.lv <= self.curLv and self.data.lv > backToTopCtrl:getFurtherRewardLv()
		obj:setEffectShow(isReward)
		if self.data.lv > self.curLv then
			obj:setItemStatus(0)
		end
		if self.data.lv <= backToTopCtrl:getFurtherRewardLv() then
			obj:setItemStatus(2)
		end
	else
		obj:setItemStatus(1)
	end
end
function Com_toTop_list:onItem3Render(index, obj)
	obj:initData(self.extraAward[index + 1].id, self.extraAward[index + 1].count)
end
function Com_toTop_list:onShow()
end
function Com_toTop_list:initData(data, curLv)
	self.data = data
	self.curLv = curLv
	self.fields.pet_lv:setString(self.data.lv)
	_UPVALUE2_ = self.data.lv
	self.data.lv[1] = "id"
	self.data.lv[2] = "count"
	self.normalData = serviceFunctions.tableFormat(self.data.reward, self.data.lv)
	_UPVALUE2_ = self.data.lv
	self.data.lv[1] = "id"
	self.data.lv[2] = "count"
	self.topData = serviceFunctions.tableFormat(self.data.PeakReward, self.data.lv)
	self.fields.List_normal:setNumItems(#self.normalData)
	self.fields.List_top:setNumItems(#self.topData)
end
function Com_toTop_list:initExtra()
	local maxCfgLv = backToTopRead.getPeakLvCfgNum()
	local lv, exp, award = backToTopRead.getExtraCfg()
	self.extraAward = award
	self.fields.pet_lv:setString(maxCfgLv .. "+")
	backToTopRead = nil
	;(nil).num = fguiHelper.getColorString("#FFC864", maxCfgLv)
	self.fields.Text_des:setString(i18n("return_peak_06", nil))
	self.fields.List_extra:setNumItems(#self.extraAward)
end
return Com_toTop_list
