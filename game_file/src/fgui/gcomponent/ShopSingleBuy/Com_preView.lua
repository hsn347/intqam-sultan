local baseComponent = require("fgui.base.baseComponent")
local Com_preView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ShopSingleBuy/Com_preView", Com_preView)
function Com_preView:onInit()
	self:fixChildrenPos()
	self.fields.frame_arrow:setRotation(SoraDFIsRA() and -90 or 90)
end
function Com_preView:onShow()
end
function Com_preView:initData(curData, nextData, itemType)
	local str = "LV"
	local strNext = "LV"
	local vipStr = "VIP"
	local svipStr = "SVIP"
	if itemType == gItemType.VIP_POINT or itemType == gItemType.S_VIP_POINT then
		str = vipStr
		strNext = vipStr
		if curData.lv > MAX_NORMAL_VIP_LV then
			str = svipStr
			curData.lv = curData.lv - MAX_NORMAL_VIP_LV
		end
		if nextData.nextLv > MAX_NORMAL_VIP_LV then
			strNext = svipStr
			nextData.nextLv = nextData.nextLv - MAX_NORMAL_VIP_LV
		end
	end
	if type(curData.percent) == "number" then
		self.fields.Text_cur:setString(str .. curData.lv .. "(" .. math.floor(curData.percent * 100) .. "%)")
	else
		self.fields.Text_cur:setString(str .. curData.lv .. "(" .. curData.percent .. ")")
	end
	if type(nextData.nextPercent) == "number" then
		self.fields.Text_next:setString(strNext .. nextData.nextLv .. "(" .. math.floor(nextData.nextPercent * 100) .. "%)")
	else
		self.fields.Text_next:setString(strNext .. nextData.nextLv .. "(" .. nextData.nextPercent .. ")")
	end
end
return Com_preView
