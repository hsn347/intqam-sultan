local romeActivityltCtrl = include("romeActivityltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_alliance = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_alliance", Com_alliance)
function Com_alliance:onInit()
	_ENV, romeActivityCtrl, self.onClickTab = nil, function(index)
		self:setTab(index)
	end, function(index)
		self:setTab(index)
	end
	;(nil).tag = 1
	;(nil).title = i18n("common_text_3050")
	_ENV, (nil).handle = self.onClickTab, self.onClickTab
	self.onClickTab.tag = 2
	self.onClickTab.title = i18n("mail_text_120")
	self.onClickTab.handle = self.onClickTab
	self.param, (function(index)
		self:setTab(index)
	end)[1] = function(index)
		self:setTab(index)
	end
	self.param, (function(index)
		self:setTab(index)
	end)[2] = function(index)
		self:setTab(index)
	end, self.onClickTab
	self.lvData = self:getLevelData()
	self.fields.List_tab:setItemRenderer(handler(self, self.onItemRendererTab))
	self.fields.List_tab:setNumItems(table.nums(self.param))
	local data = romeActivityltCtrl.getWholeRomeActivityAllRankReward(romeActivityCtrl.serverLv)
	self:initData(data, -1)
end
function Com_alliance:showScrollIcon(show)
	self.fields.icon_scroll:setVisible(show)
	if not show then
	end
end
function Com_alliance:initData(data, index)
	self.data = data
	if index and index == -1 then
		self:setTab(1)
	else
		self:setTab(self.index)
	end
end
function Com_alliance:setTab(index)
	self.index = index
	self.controllers.state:setSelectedIndex(index - 1)
	for i = 1, 2 do
		if i == index then
			self.fields.List_tab:getChildAt(i - 1):setTitleColor(cc.c3b(255, 245, 175))
			self.fields.List_tab:getChildAt(i - 1):setMask(true)
		else
			self.fields.List_tab:getChildAt(i - 1):setTitleColor(cc.c3b(144, 132, 97))
			self.fields.List_tab:getChildAt(i - 1):setMask(false)
		end
	end
	if index == 1 then
		self.fields.List_rank:setItemRenderer(handler(self, self.onItemRendererList))
		self.fields.List_rank:setNumItems(table.nums(self.data))
		self.fields.List_rank:scrollToView(0)
	else
		self.fields.Com_levelCol:initData(self.lvData)
	end
end
function Com_alliance:getLevelData()
	local i
	local transData = function(inData)
		local _ENV, outData
		for i, v in ipairs(inData) do
			outData[v.id] = v.num
		end
		return outData
	end
	_UPVALUE4_ = nil
	;(nil)[1] = i18n("common_text_1223")
	;(nil)[2] = i18n("common_text_1224")
	;(nil)[3] = i18n("common_text_1225")
	;(nil)[4] = i18n("common_text_1226")
	;(nil)[5] = i18n("common_text_1227")
	;(nil)[6] = i18n("common_text_1227")
	;(nil)[7] = i18n("common_text_1227")
	;(nil)[8] = i18n("common_text_1227")
	;(nil)[9] = i18n("common_text_1227")
	;(nil)[10] = i18n("common_text_1227")
	;(nil)[11] = i18n("common_text_1227")
	;(nil)[12] = i18n("common_text_1227")
	;(nil)[13] = i18n("common_text_1227")
	;(nil)[14] = i18n("common_text_1227")
	;(nil)[15] = i18n("common_text_1227")
	;(nil)[16] = i18n("common_text_1227")
	local (nil)[17], giftType = i18n("common_text_1227")
	local _ENV, data = i18n("common_text_1223"), i18n("common_text_1223")
	for i = 1, 10 do
		local _ENV, giftList = i18n("common_text_1227")
		for index = 1, 5 do
			local tmpList, needScore = romeActivityltCtrl.getRomeActivityLevelReward(i, index)
			_ENV = i18n("common_text_1227")
			i18n("common_text_1227").name = giftType[index]
			i18n("common_text_1227").needPoint = needScore
			i18n("common_text_1227").itemList = transData(tmpList)
			table.insert(giftList, i18n("common_text_1227"))
		end
		data[10 - i + 1] = giftList
	end
	return data
end
function Com_alliance:onItemRendererList(index, object)
	object:initData(index + 1, self.data[index + 1], "alliance")
end
function Com_alliance:onItemRendererTab(index, object)
	object:initData(index, self.param[index + 1])
end
function Com_alliance:onShow()
end
return Com_alliance
