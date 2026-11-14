local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local armyDesRead = include("armyDesRead")
local resDesRead = include("resDesRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatItemWindowPanel = class("CheatItemWindowPanel", baseFguiPanel)
function CheatItemWindowPanel:ctor(...)
	CheatItemWindowPanel.super.ctor(self, ...)
	print("CheatItemWindowPanel:ctor", self.viewName)
end
function CheatItemWindowPanel:onInit()
	print("=======CheatItemWindowPanel:onInit")
	self.onceLoad = 5
	self.totalPage = 1
	self.fields.Panel_bg:setString("我要作弊")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.Btn_right:addClickListener(handler(self, self.btnRightClick))
	self.input_name = self.fields.input_name:getChild("input")
	self.input_name:setPromptHolder("输入中文")
	self.fields.Button_search:setString("搜索")
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
end
function CheatItemWindowPanel:onItemRenderer(index, obj)
	local _index = (self.curPage - 1) * self.onceLoad + index + 1
	obj:initData(self.showItemIDList[_index], self.style)
end
function CheatItemWindowPanel:onShow()
	print("=======CheatItemWindowPanel:onShow")
	_ENV, self.style = self.param and self.param.style or 1, self.param and self.param.style or 1
	_ENV, _ENV, (self.param and self.param.style or 1).defaultClick = nil, self.style, self.style
	_ENV, self.style[1], (nil).title = nil, nil, i18n("道具")
	_ENV, self.style[2], (nil).title = nil, nil, i18n("装备")
	_ENV, self.style[3], (nil).title = nil, nil, i18n("士兵")
	_ENV, self.style[4], (nil).title = nil, nil, i18n("资源")
	;(self.param and self.param.style or 1).tabsetArray, self.style[5], (nil).title = self.style, nil, i18n("庄园")
	local (self.param and self.param.style or 1).callback, param = handler(self, self.onClickTab), self.param and self.param.style or 1
	self.fields.com_Tab:initView(param)
end
function CheatItemWindowPanel:onClickTab(tag)
	self.style = tag
	self.itemIDList, _UPVALUE0_, self.curPage = nil, nil, 1
	self:initData()
end
function CheatItemWindowPanel:initData()
	resDesRead, itemDesRead = nil, nil
	resDesRead, (nil)[1], (nil)[1] = nil, nil, "道具"
	resDesRead, (nil)[1], (nil)[2] = nil, nil, "道具名字"
	resDesRead, (nil)[1], (nil)[3] = nil, nil, "道具ID"
	resDesRead, (nil)[2], (nil)[1] = nil, nil, "装备"
	resDesRead, (nil)[2], (nil)[2] = nil, nil, "装备名字"
	resDesRead, (nil)[2], (nil)[3] = nil, nil, "装备ID"
	resDesRead, (nil)[3], (nil)[1] = nil, nil, "士兵"
	resDesRead, (nil)[3], (nil)[2] = nil, nil, "士兵名字"
	resDesRead, (nil)[3], (nil)[3] = nil, nil, "士兵ID"
	resDesRead, (nil)[4], (nil)[1] = nil, nil, "资源"
	resDesRead, (nil)[4], (nil)[2] = nil, nil, "资源名字"
	resDesRead, (nil)[4], (nil)[3] = nil, nil, "资源ID"
	;(nil)[5], (nil)[1] = nil, "庄园"
	;(nil)[5], (nil)[2] = nil, "道具名字"
	;(nil)[5], (nil)[3] = nil, "庄园内道具ID"
	local config
	local cfg = config[self.style] or config[1]
	self.fields.Text_item:setString(cfg[1])
	self.fields.Text_name:setString(cfg[2])
	self.fields.Text_id:setString(cfg[3])
	if self.style == 1 then
		local itemTable = itemDesRead.getItemConfig()
		for k, v in pairs(itemTable) do
			table.insert(self.itemIDList, k)
		end
	elseif self.style == 2 then
		local cfg = equipDesRead.getEquipQualityCfg()
		for k, v in pairs(cfg) do
			table.insert(self.itemIDList, v.compoundID)
		end
	elseif self.style == 3 then
		_UPVALUE6_ = self.style
		self.style[1] = BUILDID.STABLES
		self.style[2] = BUILDID.RANGE
		self.style[3] = BUILDID.CHARIOT_PLANT
		self.style[4] = BUILDID.BARRACKS
		self.style[5] = BUILDID.FORTRESS
		local self.style[6], buildID = BUILDID.ELITE_PALACE, self.style
		local armyLogic = include("armyLogic")
		for k, v in pairs(buildID) do
			local soldierList, maxIndex = armyLogic.getCanTrainList(v)
			for n, m in pairs(soldierList) do
				if m.iscantrain then
					table.insert(self.itemIDList, m.armyid)
				end
			end
		end
	elseif self.style == 4 then
		for k, v in pairs(resDesRead.Resinfo) do
			table.insert(self.itemIDList, k)
		end
	elseif self.style == 5 then
		local manorCityRead = include("manorCityRead")
		local pieceIDList = manorCityRead.getPieceIDList()
		for __, pieceID in ipairs(pieceIDList) do
			table.insert(self.itemIDList, pieceID)
		end
		for Item_ID, __ in pairs(manorCityRead.decoration_item) do
			table.insert(self.itemIDList, Item_ID)
		end
		local manorFarmRead = include("manorFarmRead")
		for seed, __ in pairs(manorFarmRead.farmland_seed_info) do
			table.insert(self.itemIDList, seed)
		end
		for fruit, __ in pairs(manorFarmRead.farmland_fruit_info) do
			table.insert(self.itemIDList, fruit)
		end
		for package, __ in pairs(manorFarmRead.farmland_package_info) do
			table.insert(self.itemIDList, package)
		end
	end
	table.sort(self.itemIDList, function(a, b)
		if self.style == 4 or self.style == 5 then
			return a < b
		else
			return b < a
		end
	end)
	self:updateShowItemIDList(self.itemIDList)
end
function CheatItemWindowPanel:initScroll()
	self.fields.List:setNumItems(self.onceLoad)
	self.fields.Text_page:setString(self.curPage .. "/" .. self.totalPage)
end
function CheatItemWindowPanel:btnLeftClick()
	SoraDPlaySound()
	self.curPage = self.curPage - 1
	if self.curPage < 1 then
		self.curPage = self.totalPage
	end
	self:initScroll()
end
function CheatItemWindowPanel:btnRightClick()
	SoraDPlaySound()
	self.curPage = self.curPage + 1
	if self.curPage > self.totalPage then
		self.curPage = 1
	end
	self:initScroll()
end
function CheatItemWindowPanel:btnSearchClick()
	SoraDPlaySound()
	local itemName = self.input_name:getText()
	local _ENV, result = self.input_name, self.input_name
	for __, itemID in ipairs(self.itemIDList) do
		local _itemName1 = publicRead.getName(itemID)
		local _itemName2 = tostring(itemID)
		if itemName == _itemName1 or itemName == _itemName2 then
			table.insert(result, 1, itemID)
		elseif string.find(_itemName1, itemName, 1, true) or string.find(_itemName2, itemName, 1, true) then
			table.insert(result, itemID)
		end
	end
	self:updateShowItemIDList(result)
	if self.totalPage <= 0 then
		SoraDShowMsgTip("抱歉没有搜索到相关物品")
	end
end
function CheatItemWindowPanel:updateShowItemIDList(itemIDList)
	self.totalPage = math.ceil(#itemIDList / self.onceLoad)
	self.showItemIDList = itemIDList
	self.curPage = 1
	self:initScroll()
end
return CheatItemWindowPanel
