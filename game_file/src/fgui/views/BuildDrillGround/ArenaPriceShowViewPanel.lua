local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaPriceShowViewPanel = class("ArenaPriceShowViewPanel", baseFguiPanel)
function ArenaPriceShowViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaPriceShowViewPanel:ctor", self.viewName)
end
function ArenaPriceShowViewPanel:onInit()
	print("=======ArenaPriceShowViewPanel:onInit")
	self.fields.Text_des:setString(i18n("arena_text_19"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
end
function ArenaPriceShowViewPanel:onShow()
	print("=======ArenaPriceShowViewPanel:onShow")
	local param = self.param
	self:initData(param.bType, param.blockID, param.tIndex)
end
function ArenaPriceShowViewPanel:initData(bType, blockID, tIndex)
	local arenaltCtrl = include("arenaltCtrl")
	self.battleType = bType
	self.blockID = blockID
	self.tIndex = tIndex
	self.myInfo = arenaltCtrl.getRewardByType(self.battleType, self.blockID)
	dump(self.myInfo, "wekjrwekjrhkwehrk")
	self.blockDes = arenaltCtrl.getSubSectionList(self.tIndex)
	self:initView()
end
function ArenaPriceShowViewPanel:initView(...)
	if self.battleType == gArenaBattleType.ARENA_LOCAL then
		_ENV = nil
		;(nil).group = i18n(self.blockDes.name)
		self.fields.Panel_bg:setString(i18n("arena_title_03", nil))
	elseif self.battleType == gArenaBattleType.AREAN_GLOBAL then
		_ENV = i18n("arena_title_03", nil)
		i18n("arena_title_03", nil).group = i18n(self.blockDes.name)
		self.fields.Panel_bg:setString(i18n("arena_title_04", i18n("arena_title_03", nil)))
	end
	self.fields.List:setNumItems(#self.myInfo)
end
function ArenaPriceShowViewPanel:onItemRenderer(index, obj)
	local data = self.myInfo[index + 1]
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
	end
	local ranking = data and data.ranking
	if ranking then
		local rankName = ranking[1] == ranking[2] and ranking[1] or ranking[1] .. "-" .. ranking[2]
		_ENV = nil
		;(nil).num = rankName
		_fields.Text_title:setString(i18n("common_text_617", nil))
	end
	if data and data.award then
		local itemList = SoraDIntArr2FormatTable(data.award)
		_fields.List:setItemRenderer(function(_index, _obj)
			local _data = itemList[_index + 1]
			_obj:initData(_data.id, _data.num)
		end)
		_fields.List:setNumItems(#itemList)
	end
end
return ArenaPriceShowViewPanel
