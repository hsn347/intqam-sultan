local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local commonItemShowBox = class("commonItemShowBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonItemShowBox")
	end
	return target
end)
function commonItemShowBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Node_top = SoraDGetChildByName(self, "Node_top")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.labelSubTitle = SoraDGetChildByName(self, "Text_subTitle")
	self.txtLimit = SoraDGetChildByName(self, "Text_limitTip")
	self.imgHeadBg = SoraDGetChildByName(self.Node_item, "Image_headBg")
	self.ScrollView_items = SoraDGetChildByName(self, "ScrollView_items")
	self.ScrollView_items:addEventListener(handler(self, self.scrollEventCallBack))
	self.Node_single = SoraDGetChildByName(self.ScrollView_items, "Node_single")
	self.Node_single:setVisible(false)
	self.imgHeadBg:loadTexture("bg_ZXSC_TodaysPremiumItems.png", ccui.TextureResType.plistType)
	self.tableSpare, _ENV, self.itemList, _ENV = self.imgHeadBg.loadTexture, self.imgHeadBg.loadTexture, self.imgHeadBg.loadTexture, self.imgHeadBg.loadTexture
end
local convertLvInfo = function(judgeLv)
	local des = ""
	local buildLogic = include("buildLogic")
	local warLv = buildLogic.transformBuildLvToWarLv(judgeLv)
	if 0 < warLv then
		if 0 < judgeLv % 10 then
			_ENV = nil
			_ENV = nil
			;(nil).lv = warLv
			;(nil).title = i18n("common_text_4267", nil)
			_ENV = nil
			;(nil).num = judgeLv % 10 * 10
			;(nil).char = "%"
			;(nil).des = i18n("common_text_1470", nil)
			des = i18n("common_text_2482", nil)
		else
			_ENV = nil
			;(nil).lv = warLv
			des = i18n("common_text_4267", nil)
		end
	elseif judgeLv >= CASTLE_MAXLV_NOWAR then
		if 0 < judgeLv % 10 then
			_ENV = nil
			_ENV = nil
			;(nil).lv = CASTLE_MAXLV_NOWAR
			;(nil).title = i18n("common_text_3452", nil)
			_ENV = nil
			;(nil).num = judgeLv % 10 * 10
			;(nil).char = "%"
			;(nil).des = i18n("common_text_1470", nil)
			des = i18n("common_text_2482", nil)
		else
			_ENV = nil
			;(nil).lv = CASTLE_MAXLV_NOWAR
			des = i18n("common_text_3452", nil)
		end
	else
		_ENV = nil
		;(nil).lv = judgeLv
		des = i18n("common_text_3452", nil)
	end
	return des
end
function commonItemShowBox:initData(itemID)
	local imgHeadFrame = SoraDGetChildByName(self.Node_item, "frame_item_base")
	local imgHeadItem = SoraDGetChildByName(self.Node_item, "Image_item")
	local labelHeadItemDes = SoraDGetChildByName(self.Node_item, "Text_headItemDes")
	imgHeadFrame:setSpriteFrame(publicRead.getBg(itemID))
	imgHeadItem:loadTexture(publicRead.getIcon(itemID), ccui.TextureResType.plistType)
	self.ccs_bg:setTitleName(publicRead.getName(itemID), cc.c3b(240, 230, 210))
	labelHeadItemDes:setString(publicRead.getDes(itemID))
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(itemID)
	if show == 1 then
		self.labelSubTitle:setString(i18n("common_text_4279"))
	elseif show == 2 then
		self.labelSubTitle:setString(i18n("common_text_4280"))
	elseif show == 3 then
		self.labelSubTitle:setString(i18n("common_text_4281"))
	else
		local itemType = backpackltCtrl:getResultType(itemID)
		if itemType == gItemEffectDef.OPTIONAL_HERO then
			self.labelSubTitle:setString(i18n("Endless_trial_text_22") .. i18n("common_text_4362"))
		else
			self.labelSubTitle:setString(i18n("common_text_4362"))
		end
	end
	table.sort(ret, function(l, r)
		if publicRead.getQuality(l.id) == publicRead.getQuality(r.id) then
			if l.count == r.count then
				return l.id > r.id
			else
				return l.count > r.count
			end
		else
			return publicRead.getQuality(l.id) > publicRead.getQuality(r.id)
		end
	end)
	for k, v in ipairs(ret) do
		_ENV = i18n("common_text_4362")
		i18n("common_text_4362").data = v
		_ENV, i18n("common_text_4362").point = i18n("common_text_4362")
		i18n("common_text_4362").x = 0
		self.itemList[k], i18n("common_text_4362").pos, i18n("common_text_4362").y = i18n("common_text_4362")
	end
	self:initScroll()
	self:initSingleList()
	local cond = publicRead.checkLevelCondition(itemID)
	if cond and cond.needCastleLevel then
		local des = convertLvInfo(cond.needCastleLevel)
		self.txtLimit:setString(des)
	end
end
function commonItemShowBox:initVipData(vipLv, itemList)
	self.ccs_bg:setSize(cc.size(542, 460))
	self.ccs_bg:setPositionY(-230)
	self.Node_top:setVisible(false)
	local vipLocalData = include("vipLocalData")
	if not SoraDFIsRA() then
		self.ccs_bg:setTitleName(vipLocalData:getVipSmallFntChar(vipLv))
	else
		local num, isVip = vipLocalData:getVipNum(vipLv)
		if isVip then
			self.ccs_bg:setTitleName(i18n("recharge_label_014") .. num)
		else
			_ENV = vipLocalData:getVipSmallFntChar(vipLv)
			vipLocalData:getVipSmallFntChar(vipLv).lv = num
			self.ccs_bg:setTitleName(i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv)))
		end
	end
	self.ScrollView_items:setPositionY(170)
	for k, v in ipairs(itemList) do
		_ENV = i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv))
		i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv)).data = v
		_ENV, i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv)).point = i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv))
		i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv)).x = 0
		self.itemList[k], i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv)).pos, i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv)).y = i18n("common_text_3974", vipLocalData:getVipSmallFntChar(vipLv))
	end
	self:initScroll()
	self:initSingleList()
end
function commonItemShowBox:initScroll()
	local scrollInner = self.ScrollView_items:getInnerContainer()
	local scrollInnerNewH = math.max(60 * table.nums(self.itemList), self.ScrollView_items:getContentSize().height)
	local scrollW = self.ScrollView_items:getContentSize().width
	for i, v in ipairs(self.itemList) do
		v.pos = cc.p(0.5 * scrollW, scrollInnerNewH - 60 * i)
		if v.point then
			v.point:setPosition(v.pos)
		end
	end
	self.ScrollView_items:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	self.ScrollView_items:jumpToTop()
end
function commonItemShowBox:changeTitle(title, subTitle)
	if title then
		self.ccs_bg:setTitleName(title, cc.c3b(240, 230, 210))
	end
	if subTitle then
		self.ccs_bg:setTitleName(subTitle, cc.c3b(190, 40, 40))
	end
end
function commonItemShowBox:changeHeadBg(img)
	self.imgHeadBg:loadTexture(img, ccui.TextureResType.plistType)
end
function commonItemShowBox:initSingleList()
	local scrollH = math.max(self.ScrollView_items:getContentSize().height, 60 * table.nums(self.itemList))
	local scrollInner = self.ScrollView_items:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	_ENV = scrollInner
	scrollInner.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local scrollInner.endY, tableShowH = offsetY + 1.5 * scrollH, scrollInner
	for i, v in ipairs(self.itemList) do
		if v.point then
			if v.point:getPositionY() < tableShowH.beginY or v.point:getPositionY() > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = self.Node_single:clone()
				single:addTo(self.ScrollView_items)
				single:setVisible(true)
			end
			if i % 2 == 0 then
				single:getChildByName("Image_sheer"):setVisible(false)
			end
			self:initSingle(single, v.data.id, v.data.count)
			single:setPosition(v.pos.x, v.pos.y)
			v.point = single
		end
	end
end
function commonItemShowBox:scrollEventCallBack(target, event)
	self:initSingleList()
end
function commonItemShowBox:initSingle(target, itemID, num)
	local item = SoraDGetExtendChildFromCCSByName(target, "CCS_commonItemAward_item")
	local Text_name = SoraDGetChildByName(target, "Text_name")
	local Text_num = SoraDGetChildByName(target, "Text_num")
	item:setOwnView(self)
	item:initData(itemID)
	item:setBaseScale(1.0)
	Text_name:setString(publicRead.getName(itemID))
	Text_num:setString(string.formatnumberthousands(num))
end
return commonItemShowBox
