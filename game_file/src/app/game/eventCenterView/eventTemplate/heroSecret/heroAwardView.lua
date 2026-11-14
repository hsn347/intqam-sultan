local gametop = gModuleMgr.getObject("gametop")
local heroSecretCtrl = gametop.playertop_:getModule("heroSecretCtrl")
local heroSecretltCtrl = include("heroSecretltCtrl")
local heroAwardView = class("heroAwardView", function(target)
	return target or SoraDCreateTouchPanel("heroAwardView")
end)
function heroAwardView:ctor()
	self.item_single = SoraDGetChildByName(self, "Node_single")
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hero_title_02"))
	self.ccs_bg:setSize(cc.size(580, 680))
	self.scroll = SoraDGetChildByName(self, "scroll_items")
	self:initData()
end
function heroAwardView:initData()
	local rewards = heroSecretltCtrl.getAwardByValue(heroSecretCtrl:getGroup())
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, math.max(12, table.nums(rewards)) * 90)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.item_single:setVisible(false)
	local isHaveItem = heroSecretCtrl:getItemNum()
	for i, v in ipairs(rewards) do
		local single = self.item_single:clone()
		single:addTo(self.scroll)
		single:setVisible(true)
		local item = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_item")
		item:setBaseScale(1)
		item:setOwnView(self)
		item:setOwnScroll(self.scroll)
		item:initData(v.itemid)
		local itemOrResRead
		SoraDGetChildByName(single, "img_bg_item"):setVisible(i % 2 == 0)
		if SoraDJudgeResOrItem(v.itemid) then
			itemOrResRead = include("itemDesRead")
		else
			itemOrResRead = include("resDesRead")
		end
		local item_name = SoraDGetChildByName(single, "text_name")
		if item_name then
			item_name:setString(itemOrResRead.getName(v.itemid))
		end
		if item_name:getContentSize().height > 230 then
			SoraDGetAutoHeightLabel(item_name, 230)
		end
		local item_num = SoraDGetChildByName(single, "text_num")
		if item_num then
			item_num:setString("X" .. string.formatnumberthousands(v.count))
		end
		single:setPositionY(sH - i * 90)
		local iconG = SoraDGetChildByName(single, "icon_g")
		local isGet = heroSecretCtrl:itemIsLock(v.position)
		if isGet then
			iconG:setVisible(true)
		end
		if isHaveItem then
			item_num:setPositionX(SoraDFIsRA() and 90 or 470)
		end
	end
end
return heroAwardView
