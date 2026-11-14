local hegemonRead = include("hegemonRead")
local constantRead = include("constantRead")
local hegemonPointView = class("hegemonPointView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("hegemonPointView")
	end
	return target
end)
function hegemonPointView:ctor()
	self.singleArray, _ENV = nil, nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hegemon_text_56"))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	local maxPoint = constantRead.getConstValue("MAX_GET_HEGEMON_POINTS")
	_ENV = i18n("hegemon_text_56")
	i18n("hegemon_text_56").nun = string.formatnumberthousands(maxPoint)
	self.Text_tip:setString(i18n("hegemon_text_64", i18n("hegemon_text_56")))
	self.Node_title = SoraDGetChildByName(self, "Node_title")
	self.Text_point = SoraDGetChildByName(self, "Text_point")
	self.Text_point:setString(i18n("hegemon_text_56"))
	self.Text_event = SoraDGetChildByName(self, "Text_event")
	self.Text_event:setString(i18n("legendaryking_text_50"))
	self.Image_line = SoraDGetChildByName(self, "Image_line")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.cfg = hegemonRead.getPointCfg()
	self:suitView()
	self:initData()
end
function hegemonPointView:suitView()
	local desHeight = SoraDGetAutoHeightLabel(self.Text_tip, 520)
	self.Node_title:setPositionY(self.Text_tip:getPositionY() - desHeight - 50)
	self.scroll:setPositionY(self.Node_title:getPositionY())
	self.scroll:setContentSize(cc.size(536, #self.cfg * 34))
end
function hegemonPointView:initData()
	local scrollH = #self.cfg * 34
	self.scroll:setInnerContainerSize(cc.size(536, scrollH))
	self.scroll:setBounceEnabled(false)
	self.Image_line:setContentSize(cc.size(2, 34 + #self.cfg * 34))
	for k, v in ipairs(self.cfg) do
		local single
		if k == 1 then
			single = self.Node_single
		else
			single = self.Node_single:clone()
			single:addTo(self.scroll)
		end
		self.singleArray[k] = single
		self.singleArray[k]:setPosition(268, scrollH - 34 * k)
		local Image_sheer = SoraDGetChildByName(self.singleArray[k], "Image_sheer")
		Image_sheer:setVisible(k % 2 == 0)
		local Text_score = SoraDGetChildByName(self.singleArray[k], "Text_score")
		Text_score:setString(v.score)
		local Text_name = SoraDGetChildByName(self.singleArray[k], "Text_name")
		Text_name:setString(i18n(v.des))
	end
end
return hegemonPointView
