local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local militaryFortressRead = include("militaryFortressRead")
local heroFactorDetailView = class("heroFactorDetailView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("heroFactorDetailView")
end)
function heroFactorDetailView:ctor(properties)
	self.modulusList, _ENV, self.titleList, _ENV, self.itemList, _ENV = nil, nil, nil, nil, nil, nil
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("fortress_text_12"))
	SoraDGetChildByName(self, "Text_Title"):setString(i18n("fortress_title_01"))
	self.scrollItem = SoraDGetChildByName(self, "ScrollView_item")
	self.scrollItem:addEventListener(handler(self, self.scrollEventCallBack))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.nodeTitle = SoraDGetChildByName(self, "Node_Title")
	self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX")
	self.nodeCommonTabBtnEX:setContentSize(cc.size(545, 56))
	self.nodeCommonTabBtnEX:setNewStyle(true)
	_ENV = true
	;(true).tabNum = 2
	_ENV, _ENV, (true).defaultClick = cc.size(545, 56)
	cc.size(545, 56).title = i18n("fortress_name_06")
	cc.size(545, 56).handle = handler(self, self.btnTabClick)
	cc.size(545, 56).tag = 2
	_ENV, cc.size(545, 56)[1], cc.size(545, 56).fontSize = cc.size(545, 56)
	cc.size(545, 56).title = i18n("fortress_name_07")
	cc.size(545, 56).handle = handler(self, self.btnTabClick)
	cc.size(545, 56).tag = 1
	;(true).tabsetArray, cc.size(545, 56)[2], cc.size(545, 56).fontSize = cc.size(545, 56)
	self.nodeCommonTabBtnEX:initView(true)
end
_ENV, heroFactorDetailView.updateScroll = function(self)
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local index = 0
	for i, v in ipairs(self.modulusList) do
		local single
		local posY = self.totalHeight - i * self.singleHeight
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				v.point:setVisible(true)
				self:updateItem(v, index)
				v.point:setPosition(0, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
			elseif 0 < #self.itemList then
				v.point = table.remove(self.itemList)
			else
				v.point = self.nodeSingle:clone()
				v.point:addTo(self.scrollItem)
			end
			v.point:setPosition(0, self.totalHeight - i * self.singleHeight)
			self:updateItem(v, index)
			v.point:setVisible(true)
		end
	end
end, function(self)
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local index = 0
	for i, v in ipairs(self.modulusList) do
		local single
		local posY = self.totalHeight - i * self.singleHeight
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				v.point:setVisible(true)
				self:updateItem(v, index)
				v.point:setPosition(0, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
			elseif 0 < #self.itemList then
				v.point = table.remove(self.itemList)
			else
				v.point = self.nodeSingle:clone()
				v.point:addTo(self.scrollItem)
			end
			v.point:setPosition(0, self.totalHeight - i * self.singleHeight)
			self:updateItem(v, index)
			v.point:setVisible(true)
		end
	end
end
;(function(self)
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local index = 0
	for i, v in ipairs(self.modulusList) do
		local single
		local posY = self.totalHeight - i * self.singleHeight
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				v.point:setVisible(true)
				self:updateItem(v, index)
				v.point:setPosition(0, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
			elseif 0 < #self.itemList then
				v.point = table.remove(self.itemList)
			else
				v.point = self.nodeSingle:clone()
				v.point:addTo(self.scrollItem)
			end
			v.point:setPosition(0, self.totalHeight - i * self.singleHeight)
			self:updateItem(v, index)
			v.point:setVisible(true)
		end
	end
end)[gHeroRarity.WHITE] = "icon_hero_B.png"
;(function(self)
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local index = 0
	for i, v in ipairs(self.modulusList) do
		local single
		local posY = self.totalHeight - i * self.singleHeight
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				v.point:setVisible(true)
				self:updateItem(v, index)
				v.point:setPosition(0, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
			elseif 0 < #self.itemList then
				v.point = table.remove(self.itemList)
			else
				v.point = self.nodeSingle:clone()
				v.point:addTo(self.scrollItem)
			end
			v.point:setPosition(0, self.totalHeight - i * self.singleHeight)
			self:updateItem(v, index)
			v.point:setVisible(true)
		end
	end
end)[gHeroRarity.GREEN] = "icon_hero_A.png"
;(function(self)
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local index = 0
	for i, v in ipairs(self.modulusList) do
		local single
		local posY = self.totalHeight - i * self.singleHeight
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				v.point:setVisible(true)
				self:updateItem(v, index)
				v.point:setPosition(0, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
			elseif 0 < #self.itemList then
				v.point = table.remove(self.itemList)
			else
				v.point = self.nodeSingle:clone()
				v.point:addTo(self.scrollItem)
			end
			v.point:setPosition(0, self.totalHeight - i * self.singleHeight)
			self:updateItem(v, index)
			v.point:setVisible(true)
		end
	end
end)[gHeroRarity.BLUE] = "icon_hero_S.png"
;(function(self)
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local index = 0
	for i, v in ipairs(self.modulusList) do
		local single
		local posY = self.totalHeight - i * self.singleHeight
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				v.point:setVisible(true)
				self:updateItem(v, index)
				v.point:setPosition(0, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
			elseif 0 < #self.itemList then
				v.point = table.remove(self.itemList)
			else
				v.point = self.nodeSingle:clone()
				v.point:addTo(self.scrollItem)
			end
			v.point:setPosition(0, self.totalHeight - i * self.singleHeight)
			self:updateItem(v, index)
			v.point:setVisible(true)
		end
	end
end)[gHeroRarity.PURPLE] = "icon_hero_SS.png"
local (function(self)
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local index = 0
	for i, v in ipairs(self.modulusList) do
		local single
		local posY = self.totalHeight - i * self.singleHeight
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				v.point:setVisible(true)
				self:updateItem(v, index)
				v.point:setPosition(0, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
			elseif 0 < #self.itemList then
				v.point = table.remove(self.itemList)
			else
				v.point = self.nodeSingle:clone()
				v.point:addTo(self.scrollItem)
			end
			v.point:setPosition(0, self.totalHeight - i * self.singleHeight)
			self:updateItem(v, index)
			v.point:setVisible(true)
		end
	end
end)[gHeroRarity.ORANGE], suitTbl = "icon_hero_SSS.png", function(self)
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local index = 0
	for i, v in ipairs(self.modulusList) do
		local single
		local posY = self.totalHeight - i * self.singleHeight
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				v.point:setVisible(true)
				self:updateItem(v, index)
				v.point:setPosition(0, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
			elseif 0 < #self.itemList then
				v.point = table.remove(self.itemList)
			else
				v.point = self.nodeSingle:clone()
				v.point:addTo(self.scrollItem)
			end
			v.point:setPosition(0, self.totalHeight - i * self.singleHeight)
			self:updateItem(v, index)
			v.point:setVisible(true)
		end
	end
end
function heroFactorDetailView:updateItem(v, index)
	local textModulus = SoraDGetChildByName(v.point, "Text_Modulus")
	local textRarity = SoraDGetChildByName(v.point, "Text_Rarity")
	local textParam = SoraDGetChildByName(v.point, "Text_Param")
	local ironRarity = SoraDGetChildByName(v.point, "icon_hero_Rarity")
	if v.text1 then
		textRarity:setString(i18n(v.text1))
	end
	if v.text2 then
		textParam:setVisible(true)
		textParam:setString(i18n(v.text2))
	else
		textParam:setVisible(false)
	end
	if v.text3 then
		textModulus:setString(i18n(v.text3))
	end
	local spSheer = SoraDGetChildByName(v.point, "Image_2")
	if spSheer then
		spSheer:setVisible(index % 2 == 0)
	end
	if v.rarity then
		ironRarity:setSpriteFrame(suitTbl[v.rarity])
	end
	if v.addition then
		textModulus:setString(tostring(v.addition / 10) .. "%")
	end
	if v.lv then
		textParam:setVisible(true)
		if not v.lv[2] then
			textParam:setString(v.lv[1])
		else
			_ENV = i18n(v.text3)
			i18n(v.text3).num1 = v.lv[1]
			i18n(v.text3).num2 = v.lv[2] - 1
			textParam:setString(i18n("%{num1}-%{num2}", i18n(v.text3)))
		end
	end
	if v.power then
		textParam:setVisible(true)
		if not v.power[2] then
			textParam:setString(string.formatnumberthousands(v.power[1]) .. "+")
		else
			_ENV = i18n("%{num1}-%{num2}", i18n(v.text3))
			i18n("%{num1}-%{num2}", i18n(v.text3)).num1 = string.formatnumberthousands(v.power[1])
			i18n("%{num1}-%{num2}", i18n(v.text3)).num2 = string.formatnumberthousands(v.power[2] - 1)
			textParam:setString(i18n("%{num1}-%{num2}", i18n("%{num1}-%{num2}", i18n(v.text3))))
		end
	end
end
function heroFactorDetailView:btnTabClick(tag, name)
	self:recycleAll()
	_ENV = nil
	;(nil).isTitle = true
	;(nil).text1 = "fortress_text_14"
	;(nil).text3 = "fortress_text_07"
	table.insert(self.modulusList, nil)
	for i, v in pairs(militaryFortressRead.rarityModulus[tag]) do
		if v ~= 0 then
			_ENV = nil
			;(nil).rarity = i
			;(nil).addition = v
			table.insert(self.modulusList, nil)
		end
	end
	_ENV = pairs(militaryFortressRead.rarityModulus[tag])
	pairs(militaryFortressRead.rarityModulus[tag]).isTitle = true
	pairs(militaryFortressRead.rarityModulus[tag]).text1 = "fortress_text_14"
	pairs(militaryFortressRead.rarityModulus[tag]).text2 = "fortress_title_02"
	pairs(militaryFortressRead.rarityModulus[tag]).text3 = "fortress_text_08"
	table.insert(self.modulusList, pairs(militaryFortressRead.rarityModulus[tag]))
	for i, v in pairs(militaryFortressRead.lvModulus[tag]) do
		for k, value in ipairs(v) do
			_ENV = nil
			;(nil).rarity = i
			;(nil).addition = value.addition
			;(nil).lv = value.lv
			table.insert(self.modulusList, nil)
		end
	end
	_ENV = pairs(militaryFortressRead.lvModulus[tag])
	pairs(militaryFortressRead.lvModulus[tag]).isTitle = true
	pairs(militaryFortressRead.lvModulus[tag]).text1 = "fortress_text_14"
	pairs(militaryFortressRead.lvModulus[tag]).text2 = "fortress_title_03"
	pairs(militaryFortressRead.lvModulus[tag]).text3 = "fortress_text_09"
	table.insert(self.modulusList, pairs(militaryFortressRead.lvModulus[tag]))
	for i, v in pairs(militaryFortressRead.powerModulus[tag]) do
		for k, value in ipairs(v) do
			_ENV = nil
			;(nil).rarity = i
			;(nil).addition = value.addition
			;(nil).power = value.power
			table.insert(self.modulusList, nil)
		end
	end
	self.singleHeight = 40
	self.totalHeight = math.max(478.0, #self.modulusList * self.singleHeight)
	self.scrollItem:setInnerContainerSize(cc.size(549, self.totalHeight))
	self.scrollItem:jumpToTop()
	self:updateScroll()
end
function heroFactorDetailView:recycleAll()
	for i, v in ipairs(self.modulusList) do
		if v.point then
			v.point:setVisible(false)
			if v.isTitle then
				table.insert(self.titleList, v.point)
			else
				table.insert(self.itemList, v.point)
			end
			v.point = nil
		end
	end
	self.modulusList, _ENV = ipairs(self.modulusList)
end
function heroFactorDetailView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScroll()
	end
end
return heroFactorDetailView
