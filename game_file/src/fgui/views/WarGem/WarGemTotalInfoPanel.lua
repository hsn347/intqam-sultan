local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local wargemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local ESL = require_data("enchantment_stone_level", true)
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemTotalInfoPanel = class("WarGemTotalInfoPanel", baseFguiPanel)
function WarGemTotalInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarGemTotalInfoPanel:ctor", self.viewName)
end
function WarGemTotalInfoPanel:onInit()
	print("=======WarGemTotalInfoPanel:onInit")
	self.fields.Panel_bg:setString(i18n("gemEnchant_text_02"))
	self.gemScroll = self.fields.ScrollView_gem
	self.gemScroll:setItemRenderer(handler(self, self.onGemItemRenderer))
	self.buffScroll = self.fields.ScrollView_buff
	self.buffScroll:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.txtGem = self.fields.gem_txt
	self.txtGem:setString(i18n("gemEnchant_text_03"))
	self.txtBuff = self.fields.buff_txt
	self.txtBuff:setString(i18n("gemEnchant_text_04"))
	self.emptyText = self.fields.empty_tips
	self.emptyText:setString(i18n("gemEnchant_text_12"))
	self.emptyText:setVisible(false)
end
function WarGemTotalInfoPanel:onShow()
	print("=======WarGemTotalInfoPanel:onShow")
	local index = self.proxy.param and self.proxy.param.index
	if index then
		self:initData(index)
	end
end
function WarGemTotalInfoPanel:initData(index)
	self.curIndex = index
	self.gemData = warGemCtrl:getInActGemPanelAfterAct(self.curIndex)
	self:initTotalBuff()
	if #self.attrList > 0 then
		if 0 >= #self.enchantedAttrList then
			local sSize = self.gemScroll:getContentSize()
			self.gemScroll:setContentSize(cc.size(sSize.width, sSize.height + 330))
		end
		self:refreshScroll(self.gemScroll, self.attrList)
		self.emptyText:setVisible(false)
		self.txtGem:setVisible(true)
		self.gemScroll:setVisible(true)
		self.txtBuff:setVisible(false)
		self.buffScroll:setVisible(false)
		if 0 < #self.enchantedAttrList then
			self.txtBuff:setVisible(true)
			self.buffScroll:setVisible(true)
			self:refreshScroll(self.buffScroll, self.enchantedAttrList)
		end
	else
		self.emptyText:setVisible(true)
		self.txtGem:setVisible(false)
		self.gemScroll:setVisible(false)
		self.txtBuff:setVisible(false)
		self.buffScroll:setVisible(false)
	end
end
function WarGemTotalInfoPanel:initTotalBuff(...)
	local wargemResRead, buffList
	local wargemResRead, enchantedList
	for i = 0, 10 do
		for j = 1, 3 do
			local gemID = self:getGemID(i, j)
			if 0 < gemID then
				local buffType, buffCount = wargemResRead.getAttrValueByID(gemID)
				if buffType then
					if not buffList[buffType] then
						wargemResRead = buffList[buffType]
						buffList[buffType].id = gemID
						buffList[buffType], buffList[buffType].v = buffList[buffType], buffCount or 0
					else
						buffList[buffType].v = buffList[buffType].v + buffCount
					end
				end
			end
		end
	end
	self.attrList, wargemResRead = 0, (for index)
	for k, v in pairs(buffList) do
		local strName, strValue = wargemResRead.getAttrName(k, v.v, true)
		wargemResRead = wargemResRead.getAttrValueByID(gemID)
		wargemResRead.getAttrValueByID(gemID).bType = k
		wargemResRead.getAttrValueByID(gemID).attr = strName
		wargemResRead.getAttrValueByID(gemID).id = v.id
		wargemResRead.getAttrValueByID(gemID).value = strValue
		table.insert(self.attrList, wargemResRead.getAttrValueByID(gemID))
	end
	local sortFunc = function(a, b)
		return a.id < b.id
	end
	table.sort(self.attrList, sortFunc)
	local eData = warGemCtrl:getEnchantedData()
	for k, v in pairs(eData) do
		local unlockLv = ESL.data[v.position].gemlv
		local gemId = self:getGemID(v.lv, v.idx)
		local gemlv = wargemResRead.getLevel(gemId) or 0
		if unlockLv <= gemlv and warGemCtrl:isEnchantColorValidByInfo(v) then
			local t, value, flag = wargemResRead.getEnchantmentAttrValue(v.enchantmentID, v.amount, v.strengthenLv)
			if not enchantedList[t] then
				wargemltCtrl = enchantedList[t]
				enchantedList[t], enchantedList[t][1] = enchantedList[t], v.enchantmentID
				enchantedList[t], enchantedList[t][2] = enchantedList[t], v.amount
				enchantedList[t], enchantedList[t][3] = enchantedList[t], value
				enchantedList[t], enchantedList[t][4] = enchantedList[t], flag
			else
				enchantedList[t][3] = enchantedList[t][3] + value
			end
		end
	end
	self.enchantedAttrList, wargemResRead = pairs(eData)
	for k, v in pairs(enchantedList) do
		local cfg = wargemltCtrl:getEnchantedCfg(v[1], v[2])
		local _, strName, strValue = wargemResRead.getEnchantmentAttrName(unpack(v))
		wargemResRead = unpack(v)
		unpack(v).bType = k
		unpack(v).attr = strName
		unpack(v).id = cfg.index
		unpack(v).value = strValue
		table.insert(self.enchantedAttrList, unpack(v))
	end
	table.sort(self.enchantedAttrList, sortFunc)
end
function WarGemTotalInfoPanel:getGemID(lv, idx)
	if self.gemData[tostring(lv)] then
		return self.gemData[tostring(lv)][idx] or 0
	end
	return 0
end
function WarGemTotalInfoPanel:refreshScroll(scroll, data)
	scroll:setNumItems(#data)
end
function WarGemTotalInfoPanel:onGemItemRenderer(index, obj)
	local data = self.attrList[index + 1]
	self:onItemRenderer(index, obj, data)
end
function WarGemTotalInfoPanel:onBuffItemRenderer(index, obj)
	local data = self.enchantedAttrList[index + 1]
	self:onItemRenderer(index, obj, data)
end
function WarGemTotalInfoPanel:onItemRenderer(index, obj, data)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	obj.fields.txt_template:setString(data.attr)
	obj.fields.txt_value:setString(data.value)
	obj.fields.bg_img:setVisible(index % 2 == 0)
end
return WarGemTotalInfoPanel
