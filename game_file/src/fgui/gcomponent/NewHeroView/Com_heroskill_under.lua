local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroskill_under = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_heroskill_under", Com_heroskill_under)
function Com_heroskill_under:onInit()
	self.chipItem = self:getBtnUpgrade()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Panel_bar:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Lab_lv:fixPos()
	self.fields.feed_guide_panel:addEventListener(fgui.UIEventType.Click, handler(self, self.onFeedGuideClick))
end
function Com_heroskill_under:onShow()
end
function Com_heroskill_under:onItemRenderer(index, obj)
	local id = self.itemList[index + 1].id
	local count = self.itemList[index + 1].count
	obj:initData(self.heroID, id, count)
end
function Com_heroskill_under:initData(heroID, isToOrange, buttonType, isOwn, needNum, itemNum)
	self.heroID = heroID
	self.isToOrange = isToOrange
	self.buttonType = buttonType
	self.isOwn = isOwn
	self.needNum = needNum
	self.itemNum = itemNum
	if self.isOwn then
		self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
		self.heroLevelInfo = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroInfo.level)
		self.fields.Com_advance:initData(self.heroID)
	end
	self:initView()
end
function Com_heroskill_under:updatePower()
	self.fields.Text_power:setString(string.formatnumberthousands(heroCtrl:getHeroPower(self.heroID)))
end
function Com_heroskill_under:initView()
	self.controllers.c1:setSelectedIndex(self.buttonType == gHeroButtonType.MAXLV and 1 or 0)
	self.chipItem:initData(self.heroID, self.isToOrange, self.buttonType, self.needNum, self.itemNum)
	self.fields.Text_tip:setString(i18n("hero_text_54"))
	if self.isOwn then
		if self.heroInfo.level == gHeroMaxLevel then
			self.fields.Text_tip:setString(self.isToOrange and i18n("heroDes_text_02") or i18n("heroDes_text_01"))
		end
		if self.buttonType == gHeroButtonType.MAXLV then
			self.fields.Text_tip:setString(i18n("heroDes_text_05"))
		end
		self:updatePower()
		_ENV = i18n("heroDes_text_05")
		i18n("heroDes_text_05").num = string.formatnumberthousands(self.heroLevelInfo.march_add)
		self.fields.Lab_limit:setString(i18n("hero_text_12", i18n("heroDes_text_05")))
	end
	if self.buttonType == gHeroButtonType.MAXLV then
		self.fields.Text_lvStr:setString(i18n("common_text_748"))
		self.fields.Text_max:setString(self.heroInfo.level)
	elseif self.isOwn then
		self.fields.Lab_lv:setTitle(self.heroInfo.level)
		local expPercent = self.heroInfo.level_exp / self.heroLevelInfo.exp
		self.fields.Panel_bar:setPercent(expPercent)
		_ENV = i18n("common_text_748")
		i18n("common_text_748").member = string.formatnumberthousands(self.heroInfo.level_exp)
		i18n("common_text_748").total = string.formatnumberthousands(self.heroLevelInfo.exp)
		self.fields.Text_bar:setString(i18n("common_text_155", i18n("common_text_748")))
		local heroRarity = heroltCtrl:getHeroRarity(self.heroID)
		self.itemList, _ENV = heroltCtrl, heroltCtrl
		if heroRarity == gHeroRarity.ORANGE then
			if not backpackltCtrl:getItemListByType(gItemEffectDef.SPECIAL_LEADER_POINT) then
				_ENV = backpackltCtrl:getItemListByType(gItemEffectDef.SPECIAL_LEADER_POINT)
			end
			for _, v in pairs((backpackltCtrl:getItemListByType(gItemEffectDef.SPECIAL_LEADER_POINT))) do
				local result = backpackltCtrl:getResult(v)
				if result and next(result) then
					for _, r in ipairs(result) do
						if r.rarity == heroRarity then
							_ENV = i18n("common_text_155", i18n("common_text_748"))
							i18n("common_text_155", i18n("common_text_748")).id = v
							i18n("common_text_155", i18n("common_text_748")).itemQuality = backpackltCtrl:getItemQuality(v)
							i18n("common_text_155", i18n("common_text_748")).result = result
							i18n("common_text_155", i18n("common_text_748")).count = backpackCtrl:getItemCount(v)
							table.insert(self.itemList, 1, i18n("common_text_155", i18n("common_text_748")))
							break
						end
					end
				end
			end
			table.sort(self.itemList, function(a, b)
				if a and b then
					if a.itemQuality == b.itemQuality then
						return a.result[1].count < b.result[1].count
					else
						return a.itemQuality < b.itemQuality
					end
				else
					return true
				end
			end)
		else
			local items = backpackltCtrl:getItemArray(gItemType.LEADER_POINT)
			for k, v in pairs(items) do
				local resultType = backpackltCtrl:getResultType(v)
				if resultType ~= gItemEffectDef.HERO_LEADER_POINT and resultType ~= gItemEffectDef.SPECIAL_LEADER_POINT then
					_ENV = i18n("common_text_155", i18n("common_text_748"))
					i18n("common_text_155", i18n("common_text_748")).id = v
					i18n("common_text_155", i18n("common_text_748")).itemQuality = backpackltCtrl:getItemQuality(v)
					i18n("common_text_155", i18n("common_text_748")).result = backpackltCtrl:getResult(v)
					i18n("common_text_155", i18n("common_text_748")).count = backpackCtrl:getItemCount(v)
					table.insert(self.itemList, i18n("common_text_155", i18n("common_text_748")))
				end
			end
			table.sort(self.itemList, function(a, b)
				if a and b then
					if a.itemQuality == b.itemQuality then
						return a.result[1].count < b.result[1].count
					else
						return a.itemQuality < b.itemQuality
					end
				else
					return true
				end
			end)
			if not backpackltCtrl:getItemListByType(gItemEffectDef.HERO_LEADER_POINT) then
				_ENV = backpackltCtrl:getItemListByType(gItemEffectDef.HERO_LEADER_POINT)
			end
			for _, v in pairs((backpackltCtrl:getItemListByType(gItemEffectDef.HERO_LEADER_POINT))) do
				local result = backpackltCtrl:getResult(v)
				if result and next(result) then
					for _, r in ipairs(result) do
						if r.heroID == self.heroID then
							_ENV = backpackCtrl:getItemCount(v)
							backpackCtrl:getItemCount(v).id = v
							backpackCtrl:getItemCount(v).itemQuality = backpackltCtrl:getItemQuality(v)
							backpackCtrl:getItemCount(v).result = result
							backpackCtrl:getItemCount(v).count = backpackCtrl:getItemCount(v)
							table.insert(self.itemList, 1, (backpackCtrl:getItemCount(v)))
							break
						end
					end
				end
			end
		end
		self.fields.List:setNumItems(#self.itemList)
	end
	self.chipItem:updateSpeedModel()
end
function Com_heroskill_under:getOwnItem()
	if not self.itemList then
		_ENV = self.itemList
	end
	for k, v in ipairs(self.itemList) do
		if v.count > 0 then
			self.fields.List:scrollToView(k - 1)
			return self.fields.List:getChildAt(k - 1)
		end
	end
end
function Com_heroskill_under:getBtnUpgrade()
	return self.fields.Com_advance:getChipItem()
end
function Com_heroskill_under:setBtnWeapon()
	return self.fields.Com_advance:setBtnWeapon()
end
function Com_heroskill_under:getFeedGuidePanel()
	return self.fields.feed_guide_panel
end
function Com_heroskill_under:onFeedGuideClick()
	if SoraDIsGameGuide() then
		uiManager:getProxy("newHeroDetailView").view:close()
		uiManager:getProxy("newHeroListView").view:close()
	end
end
return Com_heroskill_under
