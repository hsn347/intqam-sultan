local ExchangeEventSingle = require("fgui.gcomponent.ExchangeShopNew.ExchangeEventSingle")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local Com_exchangeCell = fgui.extension_class(fgui.GComponent, ExchangeEventSingle)
fgui.register_extension("ui://MagicLampSkill/Com_exchangeCell", Com_exchangeCell)
function Com_exchangeCell:onInit()
	print("Com_exchangeCell:onInit")
	Com_exchangeCell.super.onInit(self)
	self.exData, _ENV = Com_exchangeCell.super.onInit, Com_exchangeCell.super.onInit
end
function Com_exchangeCell:onShow()
	Com_exchangeCell.super.onShow(self)
end
function Com_exchangeCell:initData(...)
	self.exData, Com_exchangeCell = nil, nil
	Com_exchangeCell.super.initData(self, ...)
end
function Com_exchangeCell:getCount(toolID)
	return table.nums(self.exData)
end
function Com_exchangeCell:getExchangeItemCount()
	return self.exchangeitemList[1].count
end
function Com_exchangeCell:onFromItemRender(index, object)
	local skillId = self.exData[index + 1]
	object:initData(skillId, self.toolID, index, self.exData)
	object:setChangeCallback(handler(self, self.onChangeCallback))
end
function Com_exchangeCell:onChangeCallback(index, skillId)
	for i, id in pairs(self.exData) do
		if id == skillId then
			self.exData[i] = nil
		end
	end
	self.exData[index + 1] = skillId
	self:updateExChangeStatus(self.limitType)
	self:setBtnExchangeStatus()
end
function Com_exchangeCell:updateExChangeStatus(limitType)
	self.ownCount = self:getCount(self.toolID)
	self.exChangeStatus = 0
	if self.curExchangeNum >= self.limitNum then
		self.exChangeStatus = 2
	elseif self.ownCount < self.singleCount then
		self.exChangeStatus = 1
	end
end
function Com_exchangeCell:onBtnCallBack(context)
	SoraDPlaySound()
	if self.exChangeStatus == 2 then
		SoraDShowMsgTip(i18n("common_text_1865"))
	elseif self.exChangeStatus == 1 then
		SoraDShowMsgTip(i18n("common_text_2086"))
	else
		activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, 1, self.exData)
	end
end
return Com_exchangeCell
