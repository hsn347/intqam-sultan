local worldMapWarDef = include("worldMapWarDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatKingdomIDPanel = class("CheatKingdomIDPanel", baseFguiPanel)
function CheatKingdomIDPanel:ctor(...)
	CheatKingdomIDPanel.super.ctor(self, ...)
	print("CheatKingdomIDPanel:ctor", self.viewName)
	self.debug = true
end
function CheatKingdomIDPanel:onInit()
	print("=======CheatKingdomIDPanel:onInit")
	self.fields.Panel_bg:setString("游戏内王国id分配配置")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	local _ENV, ret = self.fields.List.setItemRenderer, self.fields.List.setItemRenderer
	for k, v in pairs(GAME_KINGDOM_ID_ASSIGN) do
		if k == "LEGEND" then
			for i = v.START, v.END do
				_ENV = handler(self, self.onItemRenderer)
				handler(self, self.onItemRenderer).START = i
				handler(self, self.onItemRenderer).END = i
				table.insert(ret, handler(self, self.onItemRenderer))
			end
		else
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(a, b)
		return a.START < b.START
	end)
	self.dataList = ret
	self.fields.List:setNumItems(#self.dataList)
end
function CheatKingdomIDPanel:onShow()
	print("=======CheatKingdomIDPanel:onShow")
end
function CheatKingdomIDPanel:onItemRenderer(index, obj)
	local data = self.dataList[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.Button_enter:setString("进战场")
	_fields.Button_enter:addClickListener(handlerEx(self, self.btnEnterClick, data.START))
	local kingdomName = worldMapWarDef.getKingdomNameByKid(data.START) or "游戏王国"
	if worldMapDefine.isLegendMapId(data.START) then
		kingdomName = kingdomName .. "(" .. i18n("common_text_4207") .. ")"
	end
	local kidStr = string.format("START = %d, END = %d", data.START, data.END)
	_fields.Text_name:setString(kingdomName .. "\n" .. kidStr)
end
function CheatKingdomIDPanel:btnEnterClick(kid)
	SoraDPlaySound()
	local max = worldMapDefine.getMaxCoordinateByKid(kid)
	SoraDGotoWorldMapPoint(cc.p(max * 0.5, max * 0.5), false, kid, nil, nil, true)
	SoraDRemoveAllPanelFromManager()
end
return CheatKingdomIDPanel
