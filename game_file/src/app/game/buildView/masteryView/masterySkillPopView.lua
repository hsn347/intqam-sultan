local masterySkillPopView = class("masterySkillPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("masterySkillPopView")
	end
	return target
end)
local specializationRead = include("specializationRead")
function masterySkillPopView:ctor()
	self:initWidget()
end
function masterySkillPopView:initWidget()
	self.commonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "ScrollView_up"
	self.scroll = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Sprite_icon"
	self.Sprite_icon = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_name"
	self.Text_name = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_lv"
	self.Text_lv = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	self.Text_lv:setString(i18n("specialization_text_13"))
	_UPVALUE1_ = i18n("specialization_text_13")
	i18n("specialization_text_13")[1] = "Text_value"
	self.Text_value = SoraDGetChildByFullPath(self.Node_content, i18n("specialization_text_13"))
	self.Text_value:setString(i18n("specialization_text_14"))
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Node_self = SoraDGetChildByName(self, "Node_self")
end
function masterySkillPopView:initData(data)
	self.mid = data.mid
	self.buffID = data.buffID
	self.buffLv = data.buffLv
	local buffInfo = specializationRead.getMasteryBuffInfo(self.mid, self.buffID)
	local maxLv = #buffInfo
	local bid = specializationRead.getBuildID(self.mid)
	self.commonPopBox:setTitleName(specializationRead.getMasteryName(bid))
	self.Sprite_icon:setSpriteFrame(specializationRead.getBuffIcon(self.buffID))
	self.Text_name:setString(specializationRead.getSkillPopViewBuffDes(self.buffID))
	local cellH = 37
	local totalH = cellH * maxLv + 10
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, totalH))
	for i = 1, maxLv do
		local item
		if self.buffLv == i then
			item = self.Node_self:clone()
		else
			item = self.Node_single:clone()
		end
		item:addTo(self.scroll)
		item:setPosition(cc.p(275, cellH * (maxLv - i + 0.5)))
		local Image_base = item:getChildByName("Image_base")
		if self.buffLv ~= i and i % 2 == 0 then
			Image_base:setVisible(false)
		end
		item:getChildByName("Text_lv"):setString(i)
		local info = buffInfo[i]
		item:getChildByName("Text_value"):setString(specializationRead.getMasteryBuffValue(self.mid, self.buffID, i))
	end
end
function masterySkillPopView:initScroll(...)
end
return masterySkillPopView
