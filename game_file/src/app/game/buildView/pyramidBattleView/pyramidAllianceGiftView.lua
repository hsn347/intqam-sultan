local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceWarltCtrl = include("allianceWarltCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local PyramidAllianceGiftView = class("pyramidAllianceGiftView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidAllianceGiftView")
	end
	return target
end)
function PyramidAllianceGiftView:ctor()
	self.giftSingle, _ENV, self.giftData, _ENV = nil, nil, nil, nil
	self.singleClass = nil
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.imgCopy = SoraDGetChildByName(self, "Panel_copy")
	self.itemTips = SoraDCreatePanel("commonItemTips")
	self.itemTips:addTo(self.scroll, 2)
	self.itemTips:setScale(0.8)
	self.itemTips:setVisible(false)
	self.itemTips:setPositionX(0.5 * self.scroll:getContentSize().width + SoraDFSign(110))
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_allianceTitle")
	self.title:setTitle(i18n("common_text_4017"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self:createSingleClass()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDPOSTSEASON_POSTSEASONGIFT", handler(self, self.updateSingle))
end
function PyramidAllianceGiftView:singleItemPress(itemPos, itemID)
	if itemPos == nil then
		self:closeItemInfo()
	elseif itemPos and itemID then
		self:openItemInfo(itemPos, itemID)
	end
end
function PyramidAllianceGiftView:openItemInfo(itemPos, itemID)
	print("显示")
	local curPos = self.itemTips:getParent():convertToNodeSpace(itemPos)
	self.itemTips:setPositionY(curPos.y + 120)
	self.itemTips:initData(itemID)
	self.itemTips:setVisible(true)
end
function PyramidAllianceGiftView:closeItemInfo()
	print("隐藏")
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function PyramidAllianceGiftView:updateSingle()
	for i, v in ipairs(self.giftSingle) do
		if v.btnPost:isVisible() then
			_ENV = nil
			;(nil).send = v.maxCount - pyramidWarCtrl.postSeasonGiftSendCount
			;(nil).total = v.maxCount
			v.labelNumInfo:setString(i18n("common_text_1289", nil))
			v.btnPost:setVisible(v.maxCount - pyramidWarCtrl.postSeasonGiftSendCount > 0)
		end
	end
end
function PyramidAllianceGiftView:initData(...)
	self.giftData = allianceWarltCtrl.getAlliancewarAllianceReward(gPostSeasonAllianceReward.ALLIANCE_GIFTBAG)
	self:initView()
end
function PyramidAllianceGiftView:initView()
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, self.singleClass.returnHeigh() * 3)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i = 1, 3 do
		local panel = self.singleClass.new()
		panel:setPosition(sSize.width / 2, sH - (i - 1) * panel.returnHeigh())
		panel:setRankStyle(i)
		panel:addTo(self.scroll)
		panel:initData(self.giftData[i])
		panel.itemsPressHandle = handler(self, self.singleItemPress)
		table.insert(self.giftSingle, panel)
	end
end
function PyramidAllianceGiftView:createSingleClass()
	self.singleClass = class("PyramidAllianceGiftSingle", function()
		return self.imgCopy:clone()
	end)
	function self.singleClass:ctor()
		self.itemList, _ENV = nil, nil
		self.rank = 0
		self.maxCount = 0
		self.itemsPressHandle = nil
		self.labelNumInfo = self:getChildByName("Text_numInfo")
		self.imgItem = self:getChildByName("Image_itemBg")
		self.btnRecord = self:getChildByName("Button_record")
		self.btnPost = self:getChildByName("Button_post")
		self.btnRecord:setTitleText(i18n("common_text_836"))
		self.btnPost:setTitleText(i18n("common_text_1441"))
		self.btnPost:setPosition(cc.p(320, 35))
		self.btnRecord:setVisible(false)
		self.btnPost:setVisible(false)
		self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClickCallBack))
		self.btnPost:addTouchEventListener(handler(self, self.btnPostClickCallBack))
	end
	function self.singleClass:initData(data)
		allianceWarltCtrl = nil
		self.singleInfo, (nil).rank = nil, data.point[1]
		self.maxCount = allianceWarltCtrl.getAlliancewarAllianceRewardSendMax(self.singleInfo.rank)
		if pyramidWarCtrl:getPostSeasonTop3Rank(allianceMgr:getOwnAid()) == self.singleInfo.rank then
			self.rank = self.singleInfo.rank
		end
		for i, v in ipairs(data.reward) do
			if i % 2 == 1 then
				allianceWarltCtrl = allianceMgr:getOwnAid()
				allianceMgr:getOwnAid().id = v
				allianceMgr:getOwnAid().num = data.reward[i + 1]
				table.insert(self.itemList, allianceMgr:getOwnAid())
			end
		end
		self:initView()
	end
	function self.singleClass:initView()
		local pSize = self:getContentSize()
		local iSize = cc.size(135, 115)
		local publicRead = include("publicRead")
		pyramidWarCtrl = "publicRead"
		local ("publicRead")[1], ocxList = self.imgItem, "publicRead"
		for i = 2, #self.itemList do
			local item = self.imgItem:clone()
			item:addTo(self)
			table.insert(ocxList, item)
		end
		for i, v in ipairs(ocxList) do
			v:loadTexture(publicRead.getBg(self.itemList[i].id), ccui.TextureResType.plistType)
			v:getChildByName("Image_item"):loadTexture(publicRead.getIcon(self.itemList[i].id), ccui.TextureResType.plistType)
			v:getChildByName("Text_itemNum"):setString(self.itemList[i].num)
			v:getChildByName("Button_item"):addTouchEventListener(function(button, type)
				if type == ccui.TouchEventType.ended then
					self.itemsPressHandle()
				elseif type == ccui.TouchEventType.canceled then
					self.itemsPressHandle()
				elseif type == ccui.TouchEventType.began then
					self.itemsPressHandle(v:getParent():convertToWorldSpace(cc.p(v:getPositionX(), v:getPositionY())), self.itemList[i].id)
				end
			end)
			v:setPosition(pSize.width / 2 - 3 * (iSize.width / 2) + (i - 1) % 4 * iSize.width, 240 - (math.ceil(i / 4) - 1) * iSize.height)
		end
		_ENV = self.imgItem:clone()
		self.imgItem:clone().num = self.singleInfo.rank
		self:getChildByName("Text_rank"):setString(i18n("common_text_617", (self.imgItem:clone())))
		if self.rank > 0 then
			local canShow = false
			local finishTime = pyramidWarCtrl.postSeasonBattleFinishTime
			finishTime = finishTime + 86400
			if finishTime > serviceFunctions.systemTime() then
				canShow = true
			end
			_ENV = i18n("common_text_617", (self.imgItem:clone()))
			i18n("common_text_617", (self.imgItem:clone())).send = self.maxCount - pyramidWarCtrl.postSeasonGiftSendCount
			i18n("common_text_617", (self.imgItem:clone())).total = self.maxCount
			self.labelNumInfo:setString(i18n("common_text_1289", i18n("common_text_617", (self.imgItem:clone()))))
			self.btnPost:setVisible(pyramidWarCtrl.postSeasonGiftSendCount < self.maxCount and canShow)
		else
			_ENV = pyramidWarCtrl.postSeasonGiftSendCount < self.maxCount and canShow
			;(pyramidWarCtrl.postSeasonGiftSendCount < self.maxCount and canShow).send = self.maxCount
			;(pyramidWarCtrl.postSeasonGiftSendCount < self.maxCount and canShow).total = self.maxCount
			self.labelNumInfo:setString(i18n("common_text_1289", pyramidWarCtrl.postSeasonGiftSendCount < self.maxCount and canShow))
		end
	end
	function self.singleClass:setRankStyle(rank)
		local mainOcx = self:getChildByName("Image_groupOcx")
		mainOcx:setVisible(rank <= ALLIANCE_MIN_RANK)
	end
	function self.singleClass:btnRecordClickCallBack(button, type)
		if type == ccui.TouchEventType.ended then
			print("btnRecordClickCallBack")
		end
	end
	function self.singleClass:btnPostClickCallBack(button, type)
		if type == ccui.TouchEventType.ended and allianceDesRead.checkRank(gAllianceRank.R5, true) then
			local layer = uiManager:show("LordSelectView").view
			layer:setLimitCasteLV(CASTLE_LV6_LIMITED)
			layer:initData(lordSearchType.ALLIANCE, self.maxCount - pyramidWarCtrl.postSeasonGiftSendCount, i18n("common_text_1441"))
			layer:setTitleText(i18n("common_text_2234"))
			layer:setOwnSelect(true)
			layer:setCloseSelfType(false)
			layer:setHandle(function(tableData, count, target)
				_ENV = nil
				;(nil).count = self.maxCount - pyramidWarCtrl.postSeasonGiftSendCount
				;(nil).name = i18n("common_text_4017")
				SoraDShowMsgBox(i18n("common_text_4007", nil), i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						if count >= self.maxCount - pyramidWarCtrl.postSeasonGiftSendCount then
							target:removeFromParent()
						else
							local _ENV, shieldMap = target.removeFromParent, target.removeFromParent
							for i, v in ipairs(tableData) do
								shieldMap[v] = true
							end
							layer:setMaxCount(self.maxCount - pyramidWarCtrl.postSeasonGiftSendCount - count)
							layer:setShieldMap(shieldMap)
							layer:applyData()
						end
						pyramidWarCtrl:sendPostSeasonGiftReq(tableData)
					end
				end)
			end)
			local giftData = pyramidWarCtrl.postSeasonGiftSendRecord
			dump(giftData, "giftDatagiftDatagiftData")
			if table.nums(giftData) > 0 then
				do
					local _ENV, shieldMap = table.nums(giftData), table.nums(giftData)
					for uid, v in pairs(giftData) do
						shieldMap[tonumber(uid)] = true
					end
					layer:setShieldMap(shieldMap)
				end
			end
		end
	end
	function self.singleClass.returnHeigh(...)
		return 380
	end
end
return PyramidAllianceGiftView
