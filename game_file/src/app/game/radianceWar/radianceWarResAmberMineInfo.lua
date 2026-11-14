local radianceWarDef = include("radianceWarDef")
local radianceWarResAmberMineInfo = class("radianceWarResAmberMineInfo", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("radianceWarResAmberMineInfo")
	end
	return target
end)
function radianceWarResAmberMineInfo:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("brightWar_text_219"))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.nodeSingle:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.initSingle))
	self.txtTileName = SoraDGetChildByName(self, "Text_title_name")
	self.txtTileName:setString(i18n("brightWar_text_220"))
	self.txtTileOccupy = SoraDGetChildByName(self, "Text_title_occupy")
	self.txtTileOccupy:setString(i18n("brightWar_text_221"))
	self:updateData()
end
function radianceWarResAmberMineInfo:createSingle()
	local single = self.nodeSingle:clone()
	single:setVisible(true)
	return single
end
function radianceWarResAmberMineInfo:initSingle(single, info)
	dump(info, "info", 10)
	local labelName = SoraDGetChildByName(single, "Text_content")
	local labelPower = SoraDGetChildByName(single, "Text_time")
	local strPos = string.format("%d%%", info.num or 0, info.y or 0)
	labelPower:setString(strPos)
	labelName:setString(info.str or "")
	SoraDGetChildByName(single, "Image_Bg"):setVisible(info.index % 2 ~= 0)
end
function radianceWarResAmberMineInfo:updateData(data)
	local radianceWarDef, buildData
	local tableNum = radianceWarDef.RADIANCE_PERCENT
	_UPVALUE3_ = nil
	;(nil)[1] = "brightWar_text_222"
	;(nil)[2] = "brightWar_text_223"
	local (nil)[3], tableKey = "brightWar_text_224", nil
	for i, v in pairs(tableNum) do
		radianceWarDef = nil
		;(nil).index = i
		;(nil).num = v
		;(nil).str = i18n(tableKey[i])
		table.insert(buildData, nil)
	end
	self.scroll:updateScrollView(cc.size(520, 50), buildData, 1)
end
return radianceWarResAmberMineInfo
