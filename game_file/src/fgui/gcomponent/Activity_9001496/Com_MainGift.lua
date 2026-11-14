local activity_9001496_Read = include("activity_9001496_Read")
local activity_9001496_Ctrl = SoraDGetCtrl("activity_9001496_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_MainGift = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001496/Com_MainGift", Com_MainGift)
function Com_MainGift:onInit()
	self.menuIndex = 1
	self.activityID = gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY
	self.menuList = activity_9001496_Read.getLabelList()
	self.fields.List_menu:setItemRenderer(handler(self, self.onMenuRenderer))
	self.fields.List_gift:setItemRenderer(handler(self, self.onGiftRenderer))
	self.fields.Text_none:setString(i18n("Nebulastore_text_04"))
	if 1 >= #self.menuList then
		self.fields.List_menu:setVisible(false)
		self.fields.Image_menuBg:setVisible(false)
		local offSetY = 126
		activity_9001496_Read = self.fields.Image_menuBg
		local self.fields.Image_menuBg[1], posList = self.fields.Image_top, self.fields.Image_menuBg
		for __, widget in ipairs(posList) do
			widget:setPositionY(widget:getPositionY() - offSetY)
		end
		_UPVALUE3_ = (for generator)
		ipairs(posList)[1] = self.fields.List_gift
		ipairs(posList)[2] = self.fields.Image_left
		local ipairs(posList)[3], sizePosList = self.fields.Image_right, ipairs(posList)
		for __, widget in ipairs(sizePosList) do
			widget:setPositionY(widget:getPositionY() - offSetY)
			local _size = widget:getSize()
			widget:setSize(cc.size(_size.width, _size.height + offSetY))
		end
	end
end
function Com_MainGift:onShow()
end
function Com_MainGift:onMenuRenderer(index, obj)
	obj:initData(self.menuList[index + 1], index + 1, self.menuIndex)
	obj:setClickHandle(handler(self, self.onClickMenu))
end
function Com_MainGift:onGiftRenderer(index, obj)
	obj:initDataWithActivityID(self.giftList[index + 1].cfg, self.activityID)
end
function Com_MainGift:showGift(...)
	if #self.menuList > 1 then
		self.fields.List_menu:setNumItems(#self.menuList)
	end
	self.giftList, _ENV = self.fields.List_menu.setNumItems, self.fields.List_menu.setNumItems
	local curStarLv = SoraDGetBuildStarLv()
	local ret = activity_9001496_Read.getGiftList(self.menuList[self.menuIndex].ID)
	for i, v in ipairs(ret) do
		if curStarLv >= v.LimitStarLv then
			local giftCount = activity_9001496_Ctrl:getGiftCount(v.GiftId)
			local leftBuyCount = v.ExtraData - giftCount
			_ENV = nil
			;(nil).cfg = v
			;(nil).isLimit = leftBuyCount <= 0
			;(nil).index = i
			table.insert(self.giftList, nil)
		end
	end
	table.sort(self.giftList, function(a, b)
		if a.isLimit ~= b.isLimit then
			return not a.isLimit
		end
		return a.index < b.index
	end)
	self.fields.List_gift:setNumItems(#self.giftList)
	self.fields.Text_none:setVisible(#self.giftList == 0)
end
function Com_MainGift:onClickMenu(target, menuIndex)
	if self.menuIndex == menuIndex then
		return
	end
	self.menuIndex = menuIndex
	self:showGift()
end
return Com_MainGift
