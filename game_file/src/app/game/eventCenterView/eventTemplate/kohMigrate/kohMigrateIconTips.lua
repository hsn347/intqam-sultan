local nationalFlagRead = include("nationalFlagRead")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local kohMigrateIconTips = class("kohMigrateIconTips", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kohMigrateIconTips")
	end
	return target
end)
function kohMigrateIconTips:ctor()
	self:initWidget()
end
function kohMigrateIconTips:initWidget(...)
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.Image_frm = SoraDGetChildByName(self, "Image_frm")
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.singleSize = self.Image_bg:getContentSize()
	self.nowSize = self.singleSize
end
function kohMigrateIconTips:initData(data)
	for i, v in ipairs(data) do
		local single
		if i == 1 then
			single = self.Node_content
		else
			single = self.Node_content:clone()
			single:addTo(self, 1)
			single:setPosition(0, -self.singleSize.height * (i - 1))
		end
		SoraDGetAllChildFromWidget(single, single)
		single.Sprite_icon:setSpriteFrame(v.icon)
		single.Text_name:setString(v.name)
		single.Text_des:setString(v.des)
	end
	self.nowSize = cc.size(self.singleSize.width, #data * self.singleSize.height)
	self.Image_bg:setContentSize(self.nowSize)
	self.Image_frm:setContentSize(cc.size(self.Image_frm:getContentSize().width, self.nowSize.height + 20))
end
function kohMigrateIconTips:getRootShowPos(pos, tipsOffset)
	tipsOffset = tipsOffset or 0
	if pos then
		pos.x = math.max(0, math.min(pos.x, display.width - self.nowSize.width))
		if SoraDFIsRA() then
			pos.x = pos.x + self.nowSize.width
		end
		pos.y = math.min(pos.y + self.nowSize.height + tipsOffset, display.height)
		return pos
	end
	return cc.p(display.cx, display.cy)
end
return kohMigrateIconTips
