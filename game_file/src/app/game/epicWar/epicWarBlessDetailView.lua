local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarBlessDetailView = class("epicWarBlessDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarBlessDetailView")
	end
	return target
end)
function epicWarBlessDetailView:ctor()
	self.itemsArray, _ENV = nil, nil
	self.index = 1
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Center_Node:setScale(display.height < 960 and 0.9 or 1.0)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_name:setString(i18n("epic_war_blessBuild_name"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("epic_war_blessBuild_desc"))
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Button_buy = include("commonBtnInstance").new(self.Button_buy)
	self.Button_buy:setSwallowTouches(false)
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyCallBack))
	self.Node_need = SoraDGetChildByName(self, "Node_need")
	self.Text_need = SoraDGetChildByName(self, "Text_need")
end
function epicWarBlessDetailView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_UPDATE_BLESS_CHOOSE", handler(self, self.updateView))
end
function epicWarBlessDetailView:updateView(target, data)
	self.index = data.index
	for k, v in ipairs(self.idList) do
		_ENV = nil
		;(nil).index = self.index
		self.itemsArray[k]:initData(v, nil)
	end
end
function epicWarBlessDetailView:initData(data, pos)
	self.data = data
	self.pos = pos
	self.mithrilCount = epicWarCtrl:getMithrilCount()
	local blessIdList = self.data.eventData.eventParam.blessIdList
	self.idList, epicWarCtrl, self.price = self.data.eventData.eventParam.price or 0, self.data.eventData.eventParam.price or 0, self.data.eventData.eventParam.price or 0
	for k, v in ipairs(blessIdList) do
		epicWarCtrl = nil
		;(nil).index = k
		;(nil).id = v
		;(nil).price = self.price
		table.insert(self.idList, nil)
	end
	for k, v in ipairs(self.idList) do
		local item = include("epicWarBlessSingle").new()
		epicWarCtrl = nil
		;(nil).index = self.index
		item:initData(v, nil)
		item:addTo(self.Node_items)
		item:setPosition(0, 0)
		self.itemsArray[k] = item
	end
	SoraDToCenter(self.Node_items, 174, SoraDFIsRA())
	self.Text_need:setString(self.price)
	self.Text_need:setColor(self.mithrilCount >= self.price and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	SoraDToCenter(self.Node_need)
end
function epicWarBlessDetailView:btnBuyCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.mithrilCount >= self.price then
			epicWarCtrl:sendReqTriggerEvent(self.pos, self.index)
			self:removeFromParent()
		else
			SoraDShowMsgTip(i18n("tips_silverCoins_noEnough"))
		end
	end
end
return epicWarBlessDetailView
