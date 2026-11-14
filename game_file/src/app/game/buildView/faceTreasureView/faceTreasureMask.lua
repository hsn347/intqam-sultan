local FaceTreasureMask = class("faceTreasureMask", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("faceTreasureMask")
	end
	return target
end)
function FaceTreasureMask:ctor()
	self:setBackGround(127.5)
	SoraDGetChildByName(self, "Text_load"):setString(i18n("common_text_2249"))
	SoraDGetChildByName(self, "Text_help"):setString(i18n("common_text_2250"))
	SoraDGetChildByName(self, "Text_friend"):setString(i18n("common_text_2251"))
end
return FaceTreasureMask
