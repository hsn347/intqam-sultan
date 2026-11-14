local AllianceShopLogView = class("allianceShopLogView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceShopLogView")
	end
	return target
end)
function AllianceShopLogView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.logData, _ENV, self.curType = gAllianceStoreRecordType.ITEMSHOP, gAllianceStoreRecordType.ITEMSHOP, gAllianceStoreRecordType.ITEMSHOP
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_836"))
	self.scrollLog = SoraDGetChildByName(self, "ScrollView_log")
	self.imgLogBg = SoraDGetChildByName(self, "Image_logBg")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelLog = SoraDGetChildByName(self, "Text_log")
	self.scrollLog:setVisible(false)
	SoraDSetTextWidthHeight(self.labelLog, cc.size(250, 50))
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_1959"))
	self.labelNotice:setVisible(false)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SHOP_LOG_BACK", handler(self, self.updateScrollWithData))
end
function AllianceShopLogView:initData(type)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceStore = gametop.playertop_:getModule("allianceStore")
	self.curType = type == gIDDef.ALLIANCE_HONOR and gAllianceStoreRecordType.STORE or gAllianceStoreRecordType.ITEMSHOP
	SoraDShowLoading(self)
	allianceStore:reqStoreRecord(self.curType)
end
function AllianceShopLogView:updateScrollWithData(target, data)
	SoraDCloseLoading(self)
	self.logData = data.log
	if #self.logData == 0 then
		self.labelNotice:setVisible(true)
	else
		self:showScroll()
	end
end
function AllianceShopLogView:showScroll()
	local itemDesRead = include("itemDesRead")
	local scrollSize = self.scrollLog:getContentSize()
	local scrollH = math.max(scrollSize.height, #self.logData * 70)
	local singleLabel = self.curType == gAllianceStoreRecordType.STORE and "common_text_1953" or "common_text_1960"
	self.scrollLog:setInnerContainerSize(cc.size(scrollSize.width, scrollH))
	for i, v in ipairs(self.logData) do
		local imgBg = self.imgLogBg
		local labelTime = self.labelTime
		local labelLog = self.labelLog
		if i ~= 1 then
			imgBg = imgBg:clone()
			labelTime = imgBg:getChildByName("Text_time")
			labelLog = imgBg:getChildByName("Text_log")
			imgBg:addTo(self.scrollLog)
		end
		imgBg:setPositionY(scrollH - i * 70 + 30)
		labelTime:setString(SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))
		if v.score then
			if v.system then
				_ENV = SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)
				SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true).var1 = itemDesRead.getName(v.id)
				SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true).var2 = v.count
				labelLog:setString(i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)))
			else
				_ENV = i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))
				i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)).var1 = v.name
				i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)).var2 = itemDesRead.getName(v.id)
				i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)).var3 = v.count
				labelLog:setString(i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))))
			end
		else
			_ENV = i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)))
			i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))).name = v.name
			i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))).item = itemDesRead.getName(v.id)
			i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true))).count = v.count
			labelLog:setString(i18n(singleLabel, i18n("alliance_store_returns_description_4", i18n("allianceShop_autoReturn_desc", SoraDConverSecondToDate(math.max(serviceFunctions.systemTime() - v.time, 0), false, true)))))
		end
	end
	self.scrollLog:setVisible(true)
end
return AllianceShopLogView
