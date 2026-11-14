local CrazyIntegralPriceView = class("crazyIntegralPriceView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("crazyIntegralPriceView")
	end
	return target
end)
function CrazyIntegralPriceView:ctor()
	self.barTbl, _ENV = nil, nil
	self.curRankType = gCrazyScoreRankType.UID_RANK_TYPE
	self.btnKingDom = SoraDGetChildByName(self, "Button_kingdom")
	self.btnAlliance = SoraDGetChildByName(self, "Button_alliance")
	self.btnPersonal = SoraDGetChildByName(self, "Button_personal")
	self.imgBar = SoraDGetChildByName(self, "Image_bar")
	self.imgItem = SoraDGetChildByName(self, "Image_item")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	local titleOcx = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_crazyPrice")
	titleOcx:setTitle(i18n("common_text_3048"))
	titleOcx:setTitleSize()
	self.btnKingDom:setTitleText(i18n("common_text_3051"))
	self.btnAlliance:setTitleText(i18n("common_text_3050"))
	self.btnPersonal:setTitleText(i18n("common_text_3049"))
	SoraDAutoSizeButtonText(self.btnKingDom)
	SoraDAutoSizeButtonText(self.btnAlliance)
	SoraDAutoSizeButtonText(self.btnPersonal)
	self.btnKingDom:addTouchEventListener(handler(self, self.btnKingDomClick))
	self.btnAlliance:addTouchEventListener(handler(self, self.btnAllianceClick))
	self.btnPersonal:addTouchEventListener(handler(self, self.btnPersonalClick))
	self:createClass()
	self:btnPersonalClick(self.btnPersonal, ccui.TouchEventType.ended)
end
function CrazyIntegralPriceView:initData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
	self.priceTbl = newActivityCtrl:getCrazyScoreRankReward(self.curRankType)
	self:initView()
end
function CrazyIntegralPriceView:initView()
	self.barTbl, _ENV = nil, nil
	for i, v in ipairs(self.priceTbl) do
		local bar = self.barClass.new()
		bar:initData(v, self.imgItem, self.curRankType)
		bar:foldEvent(handler(self, self.rangeBars))
		bar:addTo(self.scroll, #self.priceTbl - i)
		table.insert(self.barTbl, bar)
	end
	self:rangeBars()
	self.barTbl[1]:selfClick(self.barTbl[1], ccui.TouchEventType.ended, true)
	self.scroll:jumpToTop()
end
function CrazyIntegralPriceView:rangeBars()
	local needH = 0
	local _ENV, posYTlb
	for i, v in ipairs(self.barTbl) do
		table.insert(posYTlb, needH)
		needH = needH + v:returnHeigh()
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, needH)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.barTbl) do
		if v then
			v:setPosition(sSize.width / 2, sH - posYTlb[i])
		end
	end
end
function CrazyIntegralPriceView:createClass(...)
	self.barClass = class("CrazyIntegralPriceBar", function()
		return self.imgBar:clone()
	end)
	function self.barClass:ctor()
		self.fold = true
		_UPVALUE3_, self.itemOcxs, _ENV, self.needHeigh = nil, nil, nil, 90
		_UPVALUE3_, self.ocxNum, (nil)[1] = nil, nil, "icon_ranking_1.png"
		_UPVALUE3_, self.ocxNum, (nil)[2] = nil, nil, "icon_ranking_2.png"
		_UPVALUE3_, self.ocxNum, (nil)[3] = nil, nil, "icon_ranking_3.png"
		self.imgBoxTbl, (nil)[1] = nil, "icon_crazy_score_rank_gold.png"
		self.imgBoxTbl, (nil)[2] = nil, "icon_crazy_score_rank_silve.png"
		self.imgBoxTbl, (nil)[3] = nil, "icon_crazy_score_rank_copper.png"
		self.imgArrow = self:getChildByName("Image_arrow")
		self.imgRank = self:getChildByName("Image_rank")
		self.txtRank = self:getChildByName("Text_rank")
		self.imgBox = self:getChildByName("Image_box")
		self:setTouchEnabled(true)
		self:setSwallowTouches(false)
		self:addTouchEventListener(handler(self, self.selfClick))
	end
	function self.barClass:initData(tbl, item, classType)
		self.rankInfo = tbl.rank
		self.itemList = tbl.reward
		self.specialItem = tbl.specialGiftType
		self.copyItem = item
		if gCrazyScoreRankType.KID_RANK_TYPE == classType then
			table.insert(self.imgBoxTbl, "icon_crazy_score_service.png")
		elseif gCrazyScoreRankType.AID_RANK_TYPE == classType then
			table.insert(self.imgBoxTbl, "icon_crazy_score_alliance.png")
		elseif gCrazyScoreRankType.UID_RANK_TYPE == classType then
			table.insert(self.imgBoxTbl, "icon_crazy_score_personal.png")
		end
		self:initView()
	end
	function self.barClass:pickBoxImg(rank)
		if rank <= RANK_TOP_SPECIAL then
			return self.imgBoxTbl[rank] or self.imgBoxTbl[1]
		else
			return self.imgBoxTbl[4]
		end
	end
	function self.barClass:arrowAction(fold)
		if fold then
			self.imgArrow:setRotation(0)
		elseif SoraDFIsRA() then
			self.imgArrow:setRotation(-90)
		else
			self.imgArrow:setRotation(90)
		end
	end
	function self.barClass:initView(...)
		local switchNum = function(num)
			num = tonumber(num)
			if num <= RANK_TOP_SPECIAL then
				self.txtRank:setVisible(false)
				self.imgRank:loadTexture(self.ocxNum[num], ccui.TextureResType.plistType)
			else
				self.imgRank:setVisible(false)
				self.txtRank:setString("No." .. num)
			end
		end
		local fillItem = function(ocx, info)
			local publicRead = include("publicRead")
			local line = ocx:getChildByName("Image_line")
			local txtNum = ocx:getChildByName("Text_itemNum")
			local txtName = ocx:getChildByName("Text_itemName")
			local imgItemBg = ocx:getChildByName("Image_itemBg")
			local imgItemHead = ocx:getChildByName("Image_itemHead")
			txtNum:setString("x" .. info.num)
			txtName:setString(publicRead.getName(info.id))
			imgItemBg:loadTexture(publicRead.getBg(info.id), ccui.TextureResType.plistType)
			imgItemHead:loadTexture(publicRead.getIcon(info.id), ccui.TextureResType.plistType)
			imgItemHead:setTouchEnabled(true)
			imgItemHead:setSwallowTouches(false)
			imgItemHead:setName("image_normal_item")
			imgItemHead:setTag(info.id)
			imgItemHead:addTouchEventListener(handler(self, self.itemClick))
		end
		local fillSpecialItem = function(ocx, id)
			local newActivityRead = include("newActivityRead")
			local info = newActivityRead.getCrazySpecialRewardByID(id)
			if info then
				local itemDesRead = include("itemDesRead")
				local imgItemHead = ocx:getChildByName("Image_itemHead")
				ocx:getChildByName("Text_itemNum"):setString("x1")
				ocx:getChildByName("Text_itemName"):setString(i18n(info.giftName))
				ocx:getChildByName("Image_itemBg"):loadTexture(itemDesRead.getBgByLv(info.quality), ccui.TextureResType.plistType)
				print("info.icon = " .. info.icon)
				imgItemHead:setTouchEnabled(true)
				imgItemHead:setSwallowTouches(false)
				imgItemHead:setName("image_special_item")
				imgItemHead:setTag(id)
				imgItemHead:addTouchEventListener(handler(self, self.itemClick))
				imgItemHead:loadTexture(info.icon, ccui.TextureResType.plistType)
			end
		end
		if self.rankInfo[1] == self.rankInfo[2] then
			switchNum(self.rankInfo[1])
		else
			self.imgRank:setVisible(false)
			self.txtRank:setString("No." .. self.rankInfo[1] .. "-" .. self.rankInfo[2])
		end
		self.imgBox:ignoreContentAdaptWithSize(true)
		self.imgBox:loadTexture(self:pickBoxImg(self.rankInfo[1]), ccui.TextureResType.plistType)
		if self.fold then
			if next(self.itemOcxs) then
				for _, v in pairs(self.itemOcxs) do
					v:setVisible(false)
				end
			end
			self.needHeigh = 90
			self:arrowAction(true)
		else
			local itemH = 0
			if next(self.itemOcxs) then
				for _, v in pairs(self.itemOcxs) do
					v:setVisible(true)
				end
				itemH = #self.itemOcxs * 80
			else
				local itemList = SoraDIntArr2FormatTable(self.itemList)
				local index = 0
				print("self.specialItem", self.specialItem)
				if self.specialItem and 0 < self.specialItem then
					local item = self.copyItem:clone()
					fillSpecialItem(item, self.specialItem)
					item:addTo(self)
					item:setPosition(320, -index * 80 - 5)
					table.insert(self.itemOcxs, item)
					index = index + 1
				end
				for i, v in ipairs(itemList) do
					local item = self.copyItem:clone()
					item:addTo(self)
					fillItem(item, v)
					item:setPosition(320, -index * 80 - 5)
					table.insert(self.itemOcxs, item)
					index = index + 1
				end
				self.itemOcxs[#self.itemOcxs]:getChildByName("Image_line"):setVisible(false)
				itemH = index * 80
			end
			self.needHeigh = 90 + itemH
			self:arrowAction(false)
		end
	end
	function self.barClass:foldEvent(handl)
		self.barClick = handl
	end
	function self.barClass:selfClick(button, eventType, noSound)
		if eventType == ccui.TouchEventType.ended then
			if not noSound then
				SoraDPlaySound()
			end
			self.fold = not self.fold
			self:initView()
			if self.barClick then
				self.barClick(button)
			end
		end
	end
	function self.barClass:returnHeigh(...)
		return self.needHeigh
	end
	function self.barClass:itemClick(button, type)
		if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
			if self.pFloor then
				self.pFloor:removeFromParent()
				self.pFloor = nil
			end
		elseif type == ccui.TouchEventType.began and not self.pFloor then
			self:openItem(button, button:getTouchBeganPosition())
		end
	end
	function self.barClass:openItem(item, pos)
		self.pFloor = SoraDCreatePanel("commonItemTips")
		local _id = item:getTag()
		local _name = item:getName()
		if "image_special_item" == _name then
			local newActivityRead = include("newActivityRead")
			local info = newActivityRead.getCrazySpecialRewardByID(_id)
			self.pFloor:customData(i18n(info.giftName), i18n(info.giftDes))
		elseif "image_normal_item" == _name then
			self.pFloor:initData(_id)
		end
		pos = self.pFloor:getRootShowPos(pos)
		self.pFloor:setPosition(pos)
		local currentScene = display.getRunningScene()
		self.pFloor:addTo(currentScene, 100)
	end
end
function CrazyIntegralPriceView:switchBtns(btn, notSound)
	if not notSound then
		SoraDPlaySound()
	end
	_UPVALUE3_ = SoraDPlaySound
	SoraDPlaySound[1] = self.btnKingDom
	SoraDPlaySound[2] = self.btnAlliance
	local SoraDPlaySound[3], btns = self.btnPersonal, SoraDPlaySound
	for _, v in pairs(btns) do
		if btn == v then
			v:setTouchEnabled(false)
			v:setBright(true)
			v:setTitleColor(cc.c3b(255, 210, 138))
		else
			v:setTouchEnabled(true)
			v:setBright(false)
			v:setTitleColor(cc.c3b(85, 65, 55))
		end
	end
end
function CrazyIntegralPriceView:btnKingDomClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self:switchBtns(button)
		self.scroll:removeAllChildren()
		self.curRankType = gCrazyScoreRankType.KID_RANK_TYPE
		self:initData()
	end
end
function CrazyIntegralPriceView:btnAllianceClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self:switchBtns(button)
		self.scroll:removeAllChildren()
		self.curRankType = gCrazyScoreRankType.AID_RANK_TYPE
		self:initData()
	end
end
function CrazyIntegralPriceView:btnPersonalClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self:switchBtns(button)
		self.scroll:removeAllChildren()
		self.curRankType = gCrazyScoreRankType.UID_RANK_TYPE
		self:initData()
	end
end
return CrazyIntegralPriceView
