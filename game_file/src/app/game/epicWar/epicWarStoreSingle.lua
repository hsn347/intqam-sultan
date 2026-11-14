local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarStoreSingle = class("epicWarStoreSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarStoreSingle")
	end
	return target
end)
function epicWarStoreSingle:ctor()
	self.Image_buff = SoraDGetChildByName(self, "Image_buff")
	self.Image_quality = SoraDGetChildByName(self, "Image_quality")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Button_buy = include("commonBtnInstance").new(self.Button_buy)
	self.Button_buy:setSwallowTouches(false)
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyCallBack))
	self.Node_need = SoraDGetChildByName(self, "Node_need")
	self.Text_need = SoraDGetChildByName(self, "Text_need")
end
function epicWarStoreSingle:initData(data, otherData)
	self.tacticsId = data.tacticsId
	self.isBuy = data.isBuy
	self.index = data.index
	self.scroll = otherData.scroll
	self.pos = otherData.pos
	self.mithrilCount = epicWarCtrl:getMithrilCount()
	self.Button_buy:setScroll(self.scroll)
	local icon = epicWarltCtrl.getTacticsIcon(self.tacticsId)
	self.Image_buff:loadTexture(icon, ccui.TextureResType.plistType)
	local quality = epicWarltCtrl.getTacticsIconBase(self.tacticsId)
	self.Image_quality:loadTexture(quality, ccui.TextureResType.plistType)
	local name = epicWarltCtrl.getTacticsName(self.tacticsId)
	self.Text_name:setString(i18n(name))
	local des = epicWarltCtrl.getTacticsDes(self.tacticsId)
	self.Text_des:setString(des)
	self.price = epicWarltCtrl.getTacticsPrice(self.tacticsId)
	self.Text_need:setString(self.price)
	self.Text_need:setColor(self.mithrilCount >= self.price and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	SoraDToCenter(self.Node_need)
	self.Button_buy:setBright(not self.isBuy)
	self.Button_buy:setEnabled(not self.isBuy)
end
function epicWarStoreSingle:btnBuyCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.mithrilCount >= self.price then
			if not self.isBuy then
				local strategyList = epicWarCtrl:getCurStrategyList()
				if table.nums(strategyList) >= 8 then
					SoraDShowMsgTip(i18n("tips_tactic_numLimit"))
				else
					epicWarCtrl:sendReqTriggerEvent(self.pos, self.index)
					self.Button_buy:setBright(false)
					self.Button_buy:setEnabled(false)
				end
			end
		else
			SoraDShowMsgTip(i18n("tips_silverCoins_noEnough"))
		end
	end
end
return epicWarStoreSingle
