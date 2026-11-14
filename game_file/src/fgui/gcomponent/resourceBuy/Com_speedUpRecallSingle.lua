local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_speedUpRecallSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://resourceBuy/Com_speedUpRecallSingle", Com_speedUpRecallSingle)
function Com_speedUpRecallSingle:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Btn_buyUse:addClickListener(handler(self, self.btnBuyUseClick))
	self.fields.item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Button_use:fixPos()
	self.fields.Btn_buyUse:fixPos()
end
function Com_speedUpRecallSingle:onShow()
end
function Com_speedUpRecallSingle:initData(data, itemType, troopData)
	self.data = data
	self.itemType = itemType
	self.troopData = troopData
	self.gold = 0
	if self.data.limitData then
		self.fields.item:initData(self.data.iid)
		_ENV = nil
		;(nil).member = self.data.limitData.cur
		;(nil).total = self.data.limitData.max
		self.fields.item:setNumText(i18n("common_text_155", nil))
	else
		self.fields.item:initData(self.data.iid, self.data.count or 0)
	end
	self.fields.Text_name:setString(publicRead.getName(self.data.iid))
	self.fields.Text_des:setString(publicRead.getDes(self.data.iid))
	if self.data.count and 0 < self.data.count then
		self.fields.Button_use:setVisible(true)
		self.fields.Button_use:setGrayed(false)
		self.fields.Btn_buyUse:setVisible(false)
	elseif self.data.isUseOnly then
		self.fields.Button_use:setVisible(true)
		self.fields.Button_use:setGrayed(true)
		self.fields.Btn_buyUse:setVisible(false)
	else
		self.fields.Button_use:setVisible(false)
		self.fields.Btn_buyUse:setVisible(true)
		self.fields.Btn_buyUse:setCostTitle(self.data.gold or 0)
	end
end
function Com_speedUpRecallSingle:btnUseClick()
	SoraDPlaySound()
	if gItemType.MARCH_SPEED_UP == self.itemType then
		if self.data.count == 0 and self.data.iid == SIMULATED_DRILL_WAR_SPEEDUP_ITEM_ID then
			SoraDShowMsgTip(i18n("simulated_drill_text_57"))
			return
		end
		if self.troopData.speedUpType then
			local heroTrialCtrl = SoraDGetCtrl("heroTrialCtrl")
			heroTrialCtrl:speedUp(tonumber(self.data.iid), "ITEM")
		else
			kingdomMapCtrl:reqSpeedQueue(tonumber(self.data.iid), self.troopData.troopsID, BUILD_EXCHANGE_MODE.TOOLS)
		end
	elseif gItemType.MARCH_BACK == self.itemType then
		kingdomMapCtrl:reqRecallQueue(tonumber(self.data.iid), self.troopData.troopsID, BUILD_EXCHANGE_MODE.TOOLS)
	end
end
function Com_speedUpRecallSingle:btnBuyUseClick()
	SoraDPlaySound()
	if SoraDEnoughGold(self.gold) then
		if gItemType.MARCH_SPEED_UP == self.itemType then
			if self.troopData.speedUpType then
				local heroTrialCtrl = SoraDGetCtrl("heroTrialCtrl")
				heroTrialCtrl:speedUp(tonumber(self.data.iid), "GOLD")
			elseif include("worldMapWarDef").buySpeedUpItem(self.data.iid) then
				return true
			else
				kingdomMapCtrl:reqSpeedQueue(tonumber(self.data.iid), self.troopData.troopsID, BUILD_EXCHANGE_MODE.GOLD)
			end
		elseif gItemType.MARCH_BACK == self.itemType then
			kingdomMapCtrl:reqRecallQueue(tonumber(self.data.iid), self.troopData.troopsID, BUILD_EXCHANGE_MODE.GOLD)
		end
	end
end
return Com_speedUpRecallSingle
