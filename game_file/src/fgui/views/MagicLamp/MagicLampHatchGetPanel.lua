local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local magicLampHatchRead = include("magicLampHatchRead")
local magicLampSkillLotteryRead = include("magicLampSkillLotteryRead")
local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
local MagicLampHatchGetPanel = class("MagicLampHatchGetPanel", baseFguiPanel)
function MagicLampHatchGetPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampHatchGetPanel:ctor", self.viewName)
end
function MagicLampHatchGetPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampHatchGetPanel:onInit()
	print("=======MagicLampHatchGetPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Jinn_hatch_text_30"))
	self.fields.list:setItemRenderer(handler(self, self.onItemsRender))
end
function MagicLampHatchGetPanel:onShow()
	print("=======MagicLampHatchGetPanel:onShow")
	self.hatchType = self.param.hatchType
	self.hatchData = magicLampHatchCtrl:getHatchData(self.hatchType)
	self.desireInfo = self.hatchData.desireInfo
	self.desireCfg = magicLampHatchRead.getDesireCfg(self.hatchType, self.hatchData.lv)
	self.datas, _ENV, self.getInitCfgs = magicLampHatchRead.getGetInitCfgs(), magicLampHatchRead.getGetInitCfgs(), magicLampHatchRead.getGetInitCfgs()
	for i, v in ipairs(self.getInitCfgs) do
		local desireRecord = 0
		_ENV = nil
		local (nil).cfg, data = v, nil
		if v.type == 999 then
			_ENV = nil
			;(nil).var1 = v.getInt[2]
			;(nil).num = v.getInt[2]
			data.title = i18n("Jinn_hatch_text_31", nil)
			table.insert(self.datas, data)
		else
			local showCfg = magicLampSkillLotteryRead.getShowCfgByID(v.type)
			local poolLastTime
			local taskBeginTime = showCfg.activeTime
			local isCurPoolUnlock = magicLampSkillLotteryCtrl:getIsPoolOpenInRightArea(showCfg.magicPoolID)
			if 1 <= taskBeginTime then
				isCurPoolUnlock = magicLampSkillLotteryCtrl:getIsPoolOpen(showCfg.magicPoolID)
			end
			magicLampSkillLotteryRead = magicLampSkillLotteryCtrl
			magicLampSkillLotteryCtrl[1] = taskBeginTime
			magicLampSkillLotteryCtrl[2] = showCfg.magicPoolID
			magicLampSkillLotteryCtrl[3] = isCurPoolUnlock
			dump(magicLampSkillLotteryCtrl, "MagicLampHatchGetPanel:onShow")
			if isCurPoolUnlock then
				_ENV = "MagicLampHatchGetPanel:onShow"
				;("MagicLampHatchGetPanel:onShow").name = i18n(showCfg.magicPoolType)
				;("MagicLampHatchGetPanel:onShow").var = v.need
				;("MagicLampHatchGetPanel:onShow").var1 = v.getInt[2]
				;("MagicLampHatchGetPanel:onShow").num = v.getInt[2]
				data.title = i18n("Jinn_hatch_text_32", "MagicLampHatchGetPanel:onShow")
				data.isCurPoolUnlock = isCurPoolUnlock
				table.insert(self.datas, data)
			end
		end
	end
	self.fields.list:setNumItems(#self.datas)
end
function MagicLampHatchGetPanel:onItemsRender(index, obj)
	local data = self.datas[index + 1]
	obj:setTitle(data.title)
	obj:setIcon(data.cfg.icon)
	if data.cfg.magicPool ~= 0 then
		obj:setGoCallback(handler(self, self.onGoClick), index + 1)
	else
		obj:setGoCallback(nil)
	end
end
function MagicLampHatchGetPanel:onGoClick(idx)
	if not self.datas[idx].isCurPoolUnlock then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return
	end
	local magicPoolID = self.datas[idx].cfg.magicPool
	SoraDRemoveAllPanelFromManager()
	_ENV = i18n("common_text_2486")
	i18n("common_text_2486").magicPoolID = magicPoolID
	uiManager:show("MagicLampMaigcPowerMain", i18n("common_text_2486"))
end
return MagicLampHatchGetPanel
