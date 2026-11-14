local lightGuardianCtrl = SoraDGetCtrl("lightGuardianCtrl")
local lightGuardianPointDetail = class("lightGuardianPointDetail", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("lightGuardianPointDetail")
end)
function lightGuardianPointDetail:ctor(properties)
	_UPVALUE3_ = nil
	;(nil)[1] = "guardLight_text_09"
	;(nil)[2] = "guardLight_text_10"
	local (nil)[3], config = "guardLight_text_11", nil
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:hideTitle()
	self.detailList = SoraDGetChildsArrayByName(self, "Node_Detail_", 3, 1, true)
	self.textTitle = SoraDGetChildByName(self.node, "Text_Title")
	self.textNum = SoraDGetChildByName(self.node, "Text_Num")
	if not lightGuardianCtrl:getProperties("detail") then
		local _ENV, detailNum = lightGuardianCtrl:getProperties("detail"), lightGuardianCtrl:getProperties("detail")
	end
	for i, v in ipairs(self.detailList) do
		SoraDGetChildByName(v, "Text_Title"):setString(i18n(config[i]))
		SoraDGetChildByName(v, "Text_Num"):setString(string.formatnumberthousands(math.floor(detailNum[tostring(i)] or 0)))
	end
end
return lightGuardianPointDetail
