local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_batchBag = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_batchBag", Com_batchBag)
function Com_batchBag:onInit()
	self.chipList, _ENV = nil, nil
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_batchBag:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_HERO_CHIP_SELECT", handler(self, self.updateView))
end
function Com_batchBag:updateView(target, data)
	if data and data.chip then
		for k, v in ipairs(self.chipList) do
			if v.id == data.chip.id then
				v.isSelect = data.chip.isSelect
			end
		end
		self.fields.List:setNumItems(#self.chipList)
		self.fields.Com_bottom:initData(self, self.chipList)
	end
end
function Com_batchBag:actShow()
	self:setVisible(true)
	self.fields.Com_bottom:setPositionY(self:getHeight())
	self.fields.Com_bottom:runAction(ffa.sineIn(ffa.moveTo(0.12, self.fields.Com_bottom:getPositionX(), self:getHeight() - self.fields.Com_bottom:getHeight())))
	self.chipList, _ENV = self.fields.Com_bottom.runAction, self.fields.Com_bottom.runAction
	local itemsData = backpackCtrl:getItemsByGoodType(gItemType.HERO_CHIP)
	for k, v in ipairs(itemsData) do
		local exchangeInfo = heroltCtrl:getExchangeInfo(v.id)
		if exchangeInfo and exchangeInfo.newTokenID and exchangeInfo.newTokenNum then
			v.rarity = heroltCtrl:getItemRarity(v.id)
			v.isOwnHero = heroCtrl:getHeroInfoByID(heroltCtrl:getHeroIDByItemID(v.id)) and true or false
			table.insert(self.chipList, v)
		end
	end
	table.sort(self.chipList, function(a, b)
		if a.isOwnHero == b.isOwnHero then
			if a.rarity == b.rarity then
				return a.count > b.count
			end
			return a.rarity > b.rarity
		end
		return a.isOwnHero
	end)
	self.fields.List:setNumItems(#self.chipList)
	self.fields.Com_bottom:initData(self, self.chipList)
end
function Com_batchBag:onShow()
end
function Com_batchBag:onItemRenderer(index, obj)
	obj:initData(self.chipList[index + 1])
end
function Com_batchBag:cancel()
	for k, v in ipairs(self.chipList) do
		v.isSelect = nil
	end
	self.fields.List:setNumItems(#self.chipList)
	self:setVisible(false)
end
return Com_batchBag
