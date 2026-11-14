local petExchangeCtrl = SoraDGetCtrl("petExchangeCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local petExchangeItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/petExchangeItem", petExchangeItem)
function petExchangeItem:onInit()
	self.fields.btn_operate:addClickListener(handler(self, self.onClick_btn_operate))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function petExchangeItem:onShow()
end
function petExchangeItem:onClick_btn_operate()
	SoraDPlaySound()
	local score = petExchangeCtrl:getCurrentPoint()
	if score < self.itemData.Point then
		SoraDShowMsgTip(i18n("common_text_3827"))
		return
	end
	if self.itemsManagerHandle then
		self.itemsManagerHandle(self.itemData)
	end
end
function petExchangeItem:init(data)
	self.itemData = clone(data)
	self.itemData.id = self.itemData.ItemInfo[1]
	self.itemData.count = self.itemData.ItemInfo[2]
	local itemID = self.itemData.id
	local itemCount = self.itemData.count
	self.fields.Com_item:initData(itemID, itemCount)
	self.fields.text_name:setString(publicRead.getName(itemID))
	self.fields.btn_operate:setItemID(gIDDef.PET_POINT)
	self.fields.btn_operate:setTitleGold(string.formatnumberthousands(self.itemData.Point))
	local score = petExchangeCtrl:getCurrentPoint()
	self.fields.btn_operate:setStatus(score, self.itemData.Point)
end
function petExchangeItem:setItemDelegate(handle)
	self.itemsManagerHandle = handle
end
return petExchangeItem
