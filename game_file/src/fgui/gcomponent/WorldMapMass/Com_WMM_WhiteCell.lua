local baseComponent = require("fgui.base.baseComponent")
local Com_WMM_WhiteCell = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMapMass/Com_WMM_WhiteCell", Com_WMM_WhiteCell)
function Com_WMM_WhiteCell:onInit()
	self.fields.Check_tick:addClickListener(handler(self, self.onCheckClick))
	self:fixChildrenPos()
end
function Com_WMM_WhiteCell:onShow()
end
function Com_WMM_WhiteCell:onHide()
end
function Com_WMM_WhiteCell:initData(data, isEditMode, isSelected)
	self.data = data
	dump(data, "Com_WMM_WhiteCell:initData", 10)
	self.fields.Com_head:setHeadSprite(data.iconID or data.headid, data.avatar or "")
	local kid = data.kid or otheData.kid
	local nameStr = textParser.formatPlayerName(data.abbr or data.allianceAbbr, data.nickName or data.playerName, kid)
	self.fields.txt_name:setString(nameStr)
	self.fields.Check_tick:setSelected(isSelected)
	self.fields.Check_tick:setVisible(isEditMode)
end
function Com_WMM_WhiteCell:setSelectedCallack(callback)
	self.selectedCallback = callback
end
function Com_WMM_WhiteCell:onCheckClick()
	local isSelected = self.fields.Check_tick:isSelected()
	if self.selectedCallback then
		self.selectedCallback(self.data, isSelected)
	end
end
return Com_WMM_WhiteCell
