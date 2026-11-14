local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local commonItemShowView = class("commonItemShowView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonItemShowView")
	end
	return target
end)
function commonItemShowView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Text_info = SoraDGetChildByName(self, "Text_info")
	self.ScrollView_items = SoraDGetChildByName(self, "ScrollView_items")
	self.Node_single = SoraDGetChildByName(self.ScrollView_items, "Node_single")
end
function commonItemShowView:initData(itemID)
	local item_base = SoraDGetChildByName(self.Node_item, "frame_item_base")
	local Image_item = SoraDGetChildByName(self.Node_item, "Image_item")
	local Text_name = SoraDGetChildByName(self.Node_item, "Text_name")
	local Text_des = SoraDGetChildByName(self.Node_item, "Text_des")
	item_base:setSpriteFrame(publicRead.getBg(itemID))
	Image_item:loadTexture(publicRead.getIcon(itemID), ccui.TextureResType.plistType)
	Text_name:setString(publicRead.getName(itemID))
	SoraDSetTextWidthHeight(Text_name, cc.size(360, 60))
	Text_des:setString(publicRead.getDes(itemID))
	self:showMayGain(itemID)
end
function commonItemShowView:showMayGain(itemID)
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(itemID)
	if show == 1 then
		self.Text_info:setString(i18n("common_text_4279"))
	elseif show == 2 then
		self.Text_info:setString(i18n("common_text_4280"))
	elseif show == 3 then
		self.Text_info:setString(i18n("common_text_4281"))
	end
	if ret and next(ret) and isShow then
		local scrollH = math.max(self.ScrollView_items:getContentSize().height, 70 * table.nums(ret))
		self.ScrollView_items:setInnerContainerSize(cc.size(self.ScrollView_items:getContentSize().width, scrollH))
		for k, v in ipairs(ret) do
			local single
			if k == 1 then
				single = self.Node_single
			else
				single = self.Node_single:clone()
				single:addTo(self.ScrollView_items)
			end
			local pos = cc.p(self.ScrollView_items:getContentSize().width / 2, scrollH - 70 * k + 5)
			single:setPosition(pos)
			self:initSingle(single, v.id, v.count)
		end
	else
		self.ScrollView_items:setVisible(false)
	end
end
function commonItemShowView:initSingle(target, itemID, num)
	local item_base = SoraDGetChildByName(target, "item_base")
	local Image_item = SoraDGetChildByName(target, "Image_item")
	local Text_name = SoraDGetChildByName(target, "Text_name")
	local Text_num = SoraDGetChildByName(target, "Text_num")
	item_base:loadTexture(publicRead.getBg(itemID), ccui.TextureResType.plistType)
	Image_item:loadTexture(publicRead.getIcon(itemID), ccui.TextureResType.plistType)
	Text_name:setString(publicRead.getName(itemID))
	SoraDSetTextWidthHeight(Text_name, cc.size(330, 60))
	Text_num:setString(num)
	Image_item:setTouchEnabled(true)
	Image_item:setSwallowTouches(false)
	Image_item:addTouchEventListener(function(img, event)
		if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			if self.tips then
				self.tips:setVisible(false)
			end
		elseif event == ccui.TouchEventType.began then
			if not SoraDIsNodeVisibleOnScroll(img, self.ScrollView_items) then
				return
			end
			SoraDPlaySound()
			if not self.tips then
				self.tips = SoraDCreatePanel("commonItemTips")
				self.tips:initData(itemID)
				self.tips:setPosition(SoraDFPoint(480, 450, 640))
				self.tips:addTo(self, 9)
			else
				self.tips:initData(itemID)
				self.tips:setPosition(SoraDFPoint(480, 450, 640))
				self.tips:setVisible(true)
			end
		end
	end)
end
return commonItemShowView
