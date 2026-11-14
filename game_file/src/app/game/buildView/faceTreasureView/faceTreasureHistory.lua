local GridScrollView = include("GridScrollView")
local FaceTreasureHistory = class("faceTreasureHistory", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("faceTreasureHistory")
	end
	return target
end)
function FaceTreasureHistory:ctor()
	self.history, _ENV = nil, nil
	self.txtNoDetails = SoraDGetChildByName(self, "Text_noDetails")
	self.imgCopy = SoraDGetChildByName(self, "Image_item")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = "ScrollView_list"
	;("ScrollView_list").col = 1
	;("ScrollView_list").left = 2.5
	;("ScrollView_list").h = 1
	self.scroll:init("ScrollView_list", 0, handler(self, self.createSingle), handler(self, self.refreshSingle))
	SoraDGetChildByName(self, "Image_2"):setFillType(1)
	SoraDGetChildByName(self, "Text_title"):setString(i18n("common_text_836"))
	self.txtNoDetails:setString(i18n("common_text_2254"))
end
function FaceTreasureHistory:initData(data)
