local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_useItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_useItem", com_Meteorite_useItem)
local publicRead = include("publicRead")
function com_Meteorite_useItem:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.btnUse:addClickEventListener(handler(self, self.btnNormalUseCall))
	self.fields.btnUse:setTitle(i18n("common_text_314"))
	self.fields.btnGold:setTitle(i18n("common_text_426"))
	self.fields.btnGold:addClickEventListener(handler(self, self.btnUseGoldCall))
end
function com_Meteorite_useItem:onShow()
end
function com_Meteorite_useItem:initData(tableItem)
	self.tableItem = tableItem
	self.fields.btnGold:setCostNum(self.tableItem.gold or 0)
	self.fields.itemCount:setString(self.tableItem.count or 0)
	self.fields.txtTitle:setString(publicRead.getName(self.tableItem.iid))
	if self.fields.txtDes then
		self.fields.txtDes:setString(publicRead.getDes(self.tableItem.iid))
	end
	self.fields.itemIcon:initData(self.tableItem.iid)
	if self.tableItem.count and 0 < self.tableItem.count then
		self.fields.btnGold:setVisible(false)
		self.fields.btnUse:setVisible(true)
	else
		self.fields.btnUse:setVisible(false)
		self.fields.btnGold:setVisible(true)
	end
	if self.tableItem.isBuyOnly then
		self.fields.btnGold:setTitleStr(i18n("common_text_282"))
		self.fields.itemCount:setString("")
		self.fields.btnGold:setVisible(true)
		self.fields.btnUse:setVisible(false)
		if self.tableItem.buyCount then
			self.fields.txtTitle:setString(self.tableItem.buyCount .. "x " .. publicRead.getName(self.tableItem.iid))
		end
	end
	if self.tableItem.isbattleExclusive then
		publicRead = self.tableItem.buyCount .. "x " .. publicRead.getName(self.tableItem.iid)
		self.fields.btnGold:initData(self.tableItem.buyCount .. "x " .. publicRead.getName(self.tableItem.iid), 0)
		self.fields.btnGold:setTitleText(i18n("common_text_4347"))
	end
end
function com_Meteorite_useItem:setUseHandler(handler)
	self.useCallBack = handler
end
function com_Meteorite_useItem:btnNormalUseCall()
	SoraDPlaySound()
	if self.useCallBack then
		_ENV = nil
		;(nil).use = true
		;(nil).itemID = self.tableItem.iid
		;(nil).itemCount = self.tableItem.count or 0
		;(nil).oriData = self.tableItem
		self.useCallBack(nil)
	end
end
function com_Meteorite_useItem:btnUseGoldCall()
	SoraDPlaySound()
	if self.useCallBack then
		_ENV = nil
		;(nil).buy = true
		;(nil).needGold = self.tableItem.gold or 0
		;(nil).itemID = self.tableItem.iid
		;(nil).shopID = self.tableItem.shopID
		;(nil).oriData = self.tableItem
		self.useCallBack(nil)
	end
end
return com_Meteorite_useItem
