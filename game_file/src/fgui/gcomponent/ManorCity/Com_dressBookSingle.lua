local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_dressBookSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorCity/Com_dressBookSingle", Com_dressBookSingle)
function Com_dressBookSingle:onInit()
	self:addClickListener(handler(self, self.onClickItem))
	self.fields.mv_active1:setFrames("dh_zhangjie10_%02d.png", true, 0)
	self.fields.mv_active2:setFrames("dh_zhangjie10_%02d.png", true, 0)
	self.fields.mv_active3:setFrames("G_ygg_light_%02dsd.png", true)
	self.fields.mv_active4:setFrames("activity_ani_9001565_%02d.png", true)
	self.fields.mv_active5:setFrames("dh_tsdt_tksc_%02d.png", true)
	self.fields.mv_merge1:setFrames("dh_xingyunbzph_%02d.png", true)
	self.fields.mv_mergeEffect:setFrames("ssyj_effect_sj_%02d.png", true)
	if not SoraDFIsRA() then
		self.fields.Text_count:fixPos()
		self.fields.Image_item:fixPos()
	end
end
function Com_dressBookSingle:onShow()
	self.fields.mv_mergeEffect:setVisible(false)
end
function Com_dressBookSingle:initData(dressID)
	self.dressID = dressID
	local imageName = manorCityRead.getDressSmallImage(dressID)
	self.fields.Image_build:setURL(imageName)
	local isActive = manorCityCtrl:getDressIsActive(dressID)
	local isGet = manorCityCtrl:getDressIsGet(dressID)
	if isActive then
		self.controllers.active:setSelectedIndex(1)
		self.fields.Text_active:setString(i18n("common_text_1765"))
	elseif isGet then
		self.controllers.active:setSelectedIndex(0)
	else
		local costRes = manorCityRead.getDressCostRes(dressID, 1)
		local itemID, itemCount = costRes[1], costRes[2]
		local itemHave = manorCityCtrl:getItemCount(itemID)
		if itemCount <= itemHave then
			self.controllers.active:setSelectedIndex(3)
		else
			self.controllers.active:setSelectedIndex(2)
		end
	end
	local dressName = manorCityRead.getDressName(dressID)
	if isActive or isGet then
		local lv = manorCityCtrl:getDressLv(dressID)
		manorCityRead = self.controllers.active.setSelectedIndex
		self.controllers.active.setSelectedIndex.lv = lv
		local lvStr = i18n("common_text_100", self.controllers.active.setSelectedIndex)
		self.fields.Text_name:setString(dressName .. lvStr)
	else
		self.fields.Text_name:setString(dressName)
		local costRes = manorCityRead.getDressCostRes(dressID, 1)
		local itemID, itemCount = costRes[1], costRes[2]
		local itemIcon = manorCityRead.getDressItemIcon(itemID)
		self.fields.Image_item:setURL(itemIcon)
		local itemHave = manorCityCtrl:getItemCount(itemID)
		self.fields.Text_count:setString(itemHave .. "/" .. itemCount)
		self.fields.Text_count:setColor(itemCount <= itemHave and "#70C723" or "#E02B2B")
	end
	local isPlace = manorCityCtrl:getDressIsPlace(dressID)
	self.fields.Image_place:setVisible(isPlace)
	local canUp = manorCityCtrl:getDressCanUp(dressID)
	self.fields.Image_up:setVisible(isGet and canUp)
end
function Com_dressBookSingle:onClickItem(context)
	SoraDPlaySound()
	if self.clickCallback then
		self.clickCallback(self.dressID)
	end
end
function Com_dressBookSingle:setClickCallback(callback)
	self.clickCallback = callback
end
function Com_dressBookSingle:showMergeEffect()
	self.controllers.active:setSelectedIndex(2)
	self.fields.mv_mergeEffect:setVisible(true)
	self.transitions.t1:play(function()
		self.controllers.active:setSelectedIndex(0)
		self.fields.mv_mergeEffect:setVisible(false)
	end)
end
return Com_dressBookSingle
