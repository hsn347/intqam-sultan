local dressCtrl = SoraDGetCtrl("dressCtrl")
local castleSkinRead = include("castleSkinRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local castleChangeAttrViewPanel = class("castleChangeAttrViewPanel", baseFguiPanel)
function castleChangeAttrViewPanel:ctor(...)
	self.isLRU = true
	castleChangeAttrViewPanel.super.ctor(self, ...)
	print("castleChangeAttrViewPanel:ctor", self.viewName)
end
function castleChangeAttrViewPanel:onInit()
	print("=======castleChangeAttrViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("skin_text_14"))
	self.fields.Text_None:setString(i18n("skin_text_17"))
	self.fields.Text_None:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function castleChangeAttrViewPanel:onItemRenderer(index, obj)
	obj:initData(self.attrList[index + 1])
end
function castleChangeAttrViewPanel:endShow()
	print("=======castleChangeAttrViewPanel:endShow")
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("skin_text_15")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("skin_text_16")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_TabW:initView(nil)
end
function castleChangeAttrViewPanel:onTabClick(tag)
	self.attrList, _ENV, self.tag = nil, nil, tag
	local useAttr, ownAttr = self:getAttrList(self.tag == 1)
	if table.nums(ownAttr) > 0 then
		_ENV = nil
		table.insert(self.attrList, nil)
		self.attrList[#self.attrList].title = i18n("skin_title_02")
		local _ENV, list = self.attrList[#self.attrList], self.attrList[#self.attrList]
		for attrID, attrValue in pairs(ownAttr) do
			_ENV = nil
			;(nil).attrID = attrID
			;(nil).attrValue = attrValue
			table.insert(list, nil)
		end
		table.sort(list, function(a, b)
			return a.attrID < b.attrID
		end)
		self.attrList[#self.attrList].list = list
	end
	if table.nums(useAttr) > 0 then
		_ENV = #self.attrList
		table.insert(self.attrList, #self.attrList)
		self.attrList[#self.attrList].title = i18n("skin_title_01")
		local _ENV, list = self.attrList[#self.attrList], self.attrList[#self.attrList]
		for attrID, attrValue in pairs(useAttr) do
			_ENV = nil
			;(nil).attrID = attrID
			;(nil).attrValue = attrValue
			table.insert(list, nil)
		end
		table.sort(list, function(a, b)
			return a.attrID < b.attrID
		end)
		self.attrList[#self.attrList].list = list
	end
	self.fields.Text_None:setVisible(#self.attrList == 0)
	self.fields.List:setNumItems(#self.attrList)
	self.fields.List:jumpToTop()
end
function castleChangeAttrViewPanel:getAttrList(isAll)
	local allSkinList = dressCtrl:getDressWardrobeData()
	local dressCtrl, ownAttrList = dressCtrl, dressCtrl
	local dressCtrl, useAttrList
	for _, castleList in ipairs(allSkinList) do
		for i, v in ipairs(castleList) do
			if v.isOwn then
				if isAll or v.active then
					local useAttr = castleSkinRead.getUseAttrBySubType(v.subType)
					if next(useAttr) then
						for _, attrInfo in ipairs(useAttr) do
							if useAttrList[attrInfo.attrID] then
								useAttrList[attrInfo.attrID] = useAttrList[attrInfo.attrID] + attrInfo.attrValue
							else
								useAttrList[attrInfo.attrID] = attrInfo.attrValue
							end
						end
					end
				end
				local ownAttr = castleSkinRead.getOwnAttrBySubType(v.subType)
				if next(ownAttr) then
					for _, attrInfo in ipairs(ownAttr) do
						if ownAttrList[attrInfo.attrID] then
							ownAttrList[attrInfo.attrID] = ownAttrList[attrInfo.attrID] + attrInfo.attrValue
						else
							ownAttrList[attrInfo.attrID] = attrInfo.attrValue
						end
					end
				end
			end
		end
	end
	return useAttrList, ownAttrList
end
return castleChangeAttrViewPanel
