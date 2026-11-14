local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local warShelterCtrl = SoraDGetCtrl("warShelterCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemUseBuy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_itemUseBuy", Com_itemUseBuy)
function Com_itemUseBuy:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Btn_buyUse:setString(i18n("common_text_4436"))
	self.fields.Btn_buyUse:addClickListener(handler(self, self.btnBuyUseClick))
	self:fixChildrenPos()
end
function Com_itemUseBuy:onShow()
end
function Com_itemUseBuy:initData(data)
	self.itemID = data.iid
	self.count = data.count or 0
	self.gold = data.gold or 0
	self.shopID = data.shopID
	self.fields.item:initData(self.itemID, self.count)
	self.fields.Text_name:setString(publicRead.getName(self.itemID))
	self.fields.Text_des:setString(publicRead.getDes(self.itemID))
	if self.count > 0 then
		self.fields.Button_use:setVisible(true)
		self.fields.Btn_buyUse:setVisible(false)
	else
		self.fields.Button_use:setVisible(false)
		self.fields.Btn_buyUse:setVisible(true)
		self.fields.Btn_buyUse:setCostNum(self.gold)
	end
end
function Com_itemUseBuy:btnUseClick()
	SoraDPlaySound()
	local leftTime = warShelterCtrl:getShelterToLeftTime()
	local content = ""
	local shelter = warShelterCtrl:getShelterTo()
	if 0 < leftTime then
		_ENV = nil
		;(nil).name = shelter.name
		;(nil).item = publicRead.getName(self.itemID)
		content = i18n("war_shelter_011", nil)
	else
		_ENV = nil
		;(nil).name = shelter.name
		;(nil).item = publicRead.getName(self.itemID)
		content = i18n("war_shelter_013", nil)
	end
	_ENV = publicRead.getName(self.itemID)
	publicRead.getName(self.itemID).content = content
	publicRead.getName(self.itemID).confirmFunc = function()
		warShelterCtrl:reqOpen(self.itemID, BUILD_EXCHANGE_MODE.TOOLS)
	end
	uiManager:show("MessageBox", (publicRead.getName(self.itemID)))
end
function Com_itemUseBuy:btnBuyUseClick()
	SoraDPlaySound()
	local leftTime = warShelterCtrl:getShelterToLeftTime()
	local content = ""
	local shelter = warShelterCtrl:getShelterTo()
	if 0 < leftTime then
		_ENV = nil
		;(nil).name = shelter.name
		;(nil).num = self.gold
		;(nil).item = publicRead.getName(self.itemID)
		content = i18n("war_shelter_012", nil)
	else
		_ENV = nil
		;(nil).num = self.gold
		;(nil).name = shelter.name
		;(nil).item = publicRead.getName(self.itemID)
		content = i18n("war_shelter_014", nil)
	end
	_ENV = publicRead.getName(self.itemID)
	publicRead.getName(self.itemID).content = content
	publicRead.getName(self.itemID).confirmFunc = function()
		warShelterCtrl:reqOpen(self.itemID, BUILD_EXCHANGE_MODE.GOLD)
	end
	uiManager:show("MessageBox", (publicRead.getName(self.itemID)))
end
return Com_itemUseBuy
